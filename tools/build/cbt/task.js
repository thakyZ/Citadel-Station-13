/**
 * @file
 * @copyright 2020 Aleksej Komarov
 * @license MIT
 */

const { compareFiles, Glob, File } = require('./fs');
const fs = require('fs');

class Task {
  constructor(name) {
    this.name = name;
    this.sources = [];
    this.targets = [];
    this.scripts = [];
    this.script = null;
  }

  depends(path) {
    if (path.includes('*')) {
      this.sources.push(new Glob(path));
    }
    else {
      this.sources.push(new File(path));
    }
    return this;
  }

  provides(path) {
    if (path.includes('*')) {
      this.targets.push(new Glob(path));
    }
    else {
      this.targets.push(new File(path));
    }
    return this;
  }

  copy(path, dest) {
    this.scripts.push(async () => {
    if (fs.stat(dest, (err) => {
      if (err) {
        return;
      }
    })) {
      fs.rm(dest, { force: false, maxRetries: 1, recursive: false, retryDelay: 20 }, (err) => {
        if (err) {
          return;
        }
      });
    }});
    fs.copyFile(path, dest, (err) => {
      if (err) {
        return;
      }
    });
    return this;
  }

  insert(path, text) {
    this.scripts.push(async () => {
      const data = fs.readFileSync(path);
      const fd = fs.openSync(path, 'w+');
      const insert = new Buffer.from('#define '+text+'\n');
      fs.writeSync(fd, insert, 0, insert.length, 0);
      fs.writeSync(fd, data, 0, data.length, insert.length);
      fs.close(fd, (err) => {
        if (err) throw err;
      });
    });
    return this;
  }

  move(path, dest) {
    this.scripts.push(async () => {
    if (fs.stat(dest, (err) => {
      if (err) {
        return;
      }
    })) {
      fs.rm(dest, { force: false, maxRetries: 1, recursive: false, retryDelay: 20 }, (err) => {
        if (err) {
          return;
        }
      });
    }});
    fs.rename(path, dest, (err) => {
      if (err) {
        return;
      }
    });
    return this;
  }

  build(script) {
    this.script = script;
    return this;
  }

  async run() {
    /**
     * @returns {File[]}
     */
    const getFiles = files => files
      .flatMap(file => {
        if (file instanceof Glob) {
          return file.toFiles();
        }
        if (file instanceof File) {
          return file;
        }
      })
      .filter(Boolean);
      /**
       * @returns {Script[]}
       */
      const getScripts = scripts => scripts
        .flatMap(script => {
          if (script) {
            return script;
          }
        })
        .filter(Boolean);
    // Normalize all our dependencies by converting globs to files
    const fileSources = getFiles(this.sources);
    const fileTargets = getFiles(this.targets);
    const scripts = getScripts(this.scripts);

    if (scripts.length > 0)
    {
      this.scripts.forEach(async (e) => {
        await e();
      });
    }
    // Consider dependencies first, and skip the task if it
    // doesn't need a rebuild.
    let needsRebuild = 'no targets';
    if (fileTargets.length > 0) {
      needsRebuild = compareFiles(fileSources, fileTargets);
      if (!needsRebuild) {
        console.warn(` => Skipping '${this.name}' (up to date)`);
        return;
      }
    }
    if (!this.script) {
      return;
    }
    console.warn(` => Starting '${this.name}'`);
    const startedAt = Date.now();
    // Run the script
    await this.script();
    // Touch all targets so that they don't rebuild again
    if (fileTargets.length > 0) {
      for (const file of fileTargets) {
        file.touch();
      }
    }
    const time = ((Date.now() - startedAt) / 1000) + 's';
    console.warn(` => Finished '${this.name}' in ${time}`);
  }
}

const runTasks = async tasks => {
  const startedAt = Date.now();
  // Run all if none of the tasks were specified in command line
  const runAll = !tasks.some(task => process.argv.includes(task.name));
  for (const task of tasks) {
    if (runAll || process.argv.includes(task.name)) {
      await task.run();
    }
  }
  const time = ((Date.now() - startedAt) / 1000) + 's';
  console.log(` => Done in ${time}`);
  process.exit();
};

module.exports = {
  Task,
  runTasks
};
