/**
 * https://github.com/cemalgnlts/now
 */
const repl = require("repl");
const fs = require("fs");
const util = require("util");

const OUT_FILE = "/dev/ttyS0";

const consoleStd = fs.createWriteStream(OUT_FILE);
global.console = new console.Console(consoleStd, consoleStd);
global.console.clear = () => fs.truncateSync(OUT_FILE, 0);

const writer = output => {
    console.log(util.inspect(output));
    return "";
};

const replServer = repl.start({
    prompt: ">",
    writer: writer,
    useColors: false,
    useGlobals: false,
    ignoreUndefined: true,
    replMode: repl.REPL_MODE_STRICT,
    preview: false
});

Object.defineProperty(replServer.context, "console", {
    configurable: false,
    enumerable: true,
    value: console
});

replServer.defineCommand("run", {
    help: "Run code",
    action(file) {
        this.clearBufferedCommand();
        console.clear();

        try {
            eval(fs.readFileSync(file, "utf8"));
        } catch (err) {
            console.log(err);
        }

        this.displayPrompt();
    }
});