fs.readJsonSync = function(filename) {
    if (fs.existsSync(filename)) {
        const json = fs.readFileSync(filename, "utf8");
        return JSON.parse(json);
    }
}
path.joinLocal = function() {
    const args = Array.prototype.slice.call(arguments, 0);
    const segments = [
        process.env.HOME, ".local"
    ].concat(args);
    return path.join.apply(path, segments);
}
function loadConnections(filename) {
    function lazy(realize) {
        const args = Array.prototype.slice.call(arguments, 1);
        let obj = null;
        return function() {
            if (!obj) {
                obj = realize.apply(null, args);
            }
            return obj;
        };
    }
    function makeFindFuzzy(obj, list, prefix) {
        return function(fuzzy) {
            var name = list.find(
                (fuzzy instanceof RegExp) ?
                i => fuzzy.test(i) :
                i => i.indexOf(fuzzy) >= 0
            );
            return name && obj[prefix+name]();
        }
    }
    function fuzzyPath(path) {
        const segments = path.split('.');
        let obj = this;
        for (let i=0; i<segments.length; ++i) {
            if (!(obj && obj.fuzzy)) return null;
            obj = obj.fuzzy(segments[i]);
        }
        return obj;
    }
    function makeGettersByName(obj, list, prefix, byName) {
        const len = list.length;
        for (let i=0; i<len; ++i) {
            const name = list[i];
            obj[prefix+name] = lazy(byName, name);
        }
        obj.fuzzy = makeFindFuzzy(obj, list, prefix);
        obj.fuzzyPath = fuzzyPath;
    }
    function Database(db) {
        const prefix = "coll_";
        makeGettersByName(this, db.getCollectionNames(), prefix,
            name => db.getCollection(name));
        this.getCollection = name => this[prefix+name]();
        this.db = function() {
            globalThis.db = db;
            return this;
        };
        return this;
    }
    function Connection(srv) {
        const configDB = Mongo(srv).getDB("config");
        const databases = configDB.adminCommand({ listDatabases: 1 })
            .databases.map(d => d.name);
        makeGettersByName(this, databases, "db_",
            name => new Database(configDB.getSiblingDB(name)));
        return this;
    }
    function Connections(srvsByEnv) {
        makeGettersByName(this, Object.keys(srvsByEnv), "conn_",
            env => new Connection(srvsByEnv[env]));
        return this;
    }
    const srvs = fs.readJsonSync(filename);
    if (srvs) {
        return new Connections(srvs);
    }
    console.log(`\nCould not read connections JSON from file '${filename}'`);
};

if (fs.existsSync(path.joinLocal("mongoshrc"))) {
    load(path.joinLocal("mongoshrc"));
} else {
    globalThis.connByEnv =
        loadConnections(path.joinLocal("mongoconn.json"));
}

