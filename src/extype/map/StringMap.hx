package extype.map;

import extype.Map.IMap;
#if js
import js.lib.Map in JsMap;
#else
import haxe.ds.StringMap in StdMap;
#end

/**
    Represents a Map object of `String` keys.
**/
class StringMap<V> implements IMap<String, V> {
    #if js
    final map:JsMap<String, V>;
    #elseif neko
    var hash:Dynamic;
    #else
    final map:StdMap<V>;
    var _length:Int;
    #end

    /**
        Returns the number of key/value pairs in this Map object.
    **/
    public var length(get, never):Int;

    public inline function new() {
        #if js
        map = new JsMap();
        #elseif neko
        hash = untyped __dollar__hnew(0);
        #else
        map = new StdMap();
        _length = 0;
        #end
    }

    /**
        Returns the current mapping of `key`.
    **/
    public inline function get(key:String):Null<V> {
        #if neko
        return untyped __dollar__hget(hash, key.__s, null);
        #else
        return map.get(key);
        #end
    }

    /**
        Maps key to value.

        If `key` already has a mapping, the previous value disappears.

        If `key` is `null`, the result is unspecified.
    **/
    public inline function set(key:String, value:V):Void {
        #if js
        map.set(key, value);
        #elseif neko
        untyped __dollar__hset(hash, key.__s, value, null);
        #else
        if (!map.exists(key)) _length++;
        map.set(key, value);
        #end
    }

    /**
        Returns true if key `has` a mapping, false otherwise.

        If `key` is `null`, the result is unspecified.
    **/
    public inline function exists(key:String):Bool {
        #if js
        return map.has(key);
        #elseif neko
        return untyped __dollar__hmem(hash, key.__s, null);
        #else
        return map.exists(key);
        #end
    }

    /**
        Removes the mapping of key and returns true if such a mapping existed, false otherwise.

        If `key` is `null`, the result is unspecified.
    **/
    public inline function remove(key:String):Bool {
        #if js
        return map.delete(key);
        #elseif neko
        return untyped __dollar__hremove(hash, key.__s, null);
        #else
        final ret = map.remove(key);
        if (ret) _length--;
        return ret;
        #end
    }

    /**
        Returns an Iterator over the keys of this Map.
    **/
    public inline function keys():Iterator<String> {
        #if js
        return new js.lib.HaxeIterator(map.keys());
        #elseif neko
        final list = new List<String>();
        untyped __dollar__hiter(hash, (k, _) -> {
            list.push(new String(k));
        });
        return list.iterator();
        #else
        return map.keys();
        #end
    }

    /**
        Returns an Iterator over the values of this Map.
    **/
    public inline function iterator():Iterator<V> {
        #if js
        return map.iterator();
        #elseif neko
        final list = new List<V>();
        untyped __dollar__hiter(hash, (_, v) -> {
            list.push(v);
        });
        return list.iterator();
        #else
        return map.iterator();
        #end
    }

    /**
        Returns an Iterator over the keys and values of this Map.
    **/
    public inline function keyValueIterator():KeyValueIterator<String, V> {
        #if js
        return new extype._internal.HaxeKeyValueIterator(map.entries());
        #elseif neko
        final list = new List<StringMapEntry<V>>();
        untyped __dollar__hiter(hash, (k, v) -> {
            list.push(new StringMapEntry(new String(k), v));
        });
        return list.iterator();
        #else
        return map.keyValueIterator();
        #end
    }

    /**
        Returns a shallow copy of this Map.
    **/
    public inline function copy():StringMap<V> {
        final newMap = new StringMap();
        #if js
        map.forEach((v, k, _) -> newMap.set(k, v));
        #elseif neko
        for (k => v in this) newMap.set(k, v);
        #else
        for (k => v in map) newMap.set(k, v);
        #end
        return newMap;
    }

    /**
        Returns a String representation of this Map.
    **/
    public inline function toString():String {
        final buff = [];
        #if js
        map.forEach((v, k, _) -> buff.push('${k}=>${v}'));
        #elseif neko
        for (k => v in this) buff.push('${k}=>${v}');
        #else
        for (k => v in map) buff.push('${k}=>${v}');
        #end
        return '[${buff.join(",")}]';
    }

    /**
        Removes all keys from this Map.
    **/
    public inline function clear():Void {
        #if js
        map.clear();
        #elseif neko
        hash = untyped __dollar__hnew(0);
        #else
        map.clear();
        _length = 0;
        #end
    }

    inline function get_length():Int {
        #if js
        return map.size;
        #elseif neko
        return untyped __dollar__hcount(hash);
        #else
        return _length;
        #end
    }
}

#if neko
private class StringMapEntry<V> {
    public var key:String;
    public var value:V;

    public function new(key:String, value:V) {
        this.key = key;
        this.value = value;
    }
}
#end