package extype.orderedmap;

import extype.OrderedMap.IOrderedMap;
#if js
import js.lib.Map in JsMap;
#else
import extype.LinkedList;
import haxe.ds.IntMap in StdMap;
#end

/**
    Represents a Map object of `Int` keys.
    You can iterate through the keys in insertion order.
**/
class OrderedIntMap<V> implements IOrderedMap<Int, V> {
    #if js
    final map:JsMap<Int, V>;
    #else
    final map:StdMap<LinkedListNode<Pair<Int, V>>>;
    final list:LinkedList<Pair<Int, V>>;
    #end

    /**
        Returns the number of key/value pairs in this Map object.
    **/
    public var length(get, never):Int;

    public inline function new() {
        #if js
        this.map = new JsMap();
        #else
        this.map = new StdMap();
        this.list = new LinkedList();
        #end
    }

    /**
        Returns the current mapping of `key`.
    **/
    public inline function get(key:Int):Null<V> {
        #if js
        return map.get(key);
        #else
        final node = Nullable.of(map.get(key));
        return node.map(x -> x.value.value2).get();
        #end
    }

    /**
        Maps key to value.

        If `key` already has a mapping, the previous value disappears.

        If `key` is `null`, the result is unspecified.
    **/
    public inline function set(key:Int, value:V):Void {
        #if js
        map.set(key, value);
        #else
        if (map.exists(key)) {
            list.remove(map.get(key));
        }
        map.set(key, list.add(new Pair(key, value)));
        #end
    }

    /**
        Returns true if key `has` a mapping, false otherwise.

        If `key` is `null`, the result is unspecified.
    **/
    public inline function exists(key:Int):Bool {
        #if js
        return map.has(key);
        #else
        return map.exists(key);
        #end
    }

    /**
        Removes the mapping of key and returns true if such a mapping existed, false otherwise.

        If `key` is `null`, the result is unspecified.
    **/
    public inline function remove(key:Int):Bool {
        #if js
        return map.delete(key);
        #else
        return if (map.exists(key)) {
            list.remove(map.get(key));
            map.remove(key);
            true;
        } else {
            false;
        }
        #end
    }

    /**
        Returns an Iterator over the keys of this Map.
    **/
    public inline function keys():Iterator<Int> {
        #if js
        return new js.lib.HaxeIterator(map.keys());
        #else
        return new extype._internal.TransformIterator(list.iterator(), pair -> pair.value1);
        #end
    }

    /**
        Returns an Iterator over the values of this Map.
    **/
    public inline function iterator():Iterator<V> {
        #if js
        return map.iterator();
        #else
        return new extype._internal.TransformIterator(list.iterator(), pair -> pair.value2);
        #end
    }

    /**
        Returns an Iterator over the keys and values of this Map.
    **/
    public inline function keyValueIterator():KeyValueIterator<Int, V> {
        #if js
        return new extype._internal.HaxeKeyValueIterator<Int, V>(map.entries());
        #else
        return new extype._internal.TransformIterator(list.iterator(), pair -> new IntMapEntry(pair.value1, pair.value2));
        #end
    }

    /**
        Returns a shallow copy of this Map.
    **/
    public inline function copy():OrderedIntMap<V> {
        final newMap = new OrderedIntMap();
        #if js
        map.forEach((v, k, _) -> newMap.set(k, v));
        #else
        list.iter(pair -> newMap.set(pair.value1, pair.value2));
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
        #else
        list.iter(pair -> buff.push('${pair.value1}=>${pair.value2}'));
        #end
        return '[${buff.join(",")}]';
    }

    /**
        Removes all keys from this Map.
    **/
    public inline function clear():Void {
        map.clear();
        #if !js
        list.clear();
        #end
    }

    inline function get_length():Int {
        #if js
        return map.size;
        #else
        return list.length;
        #end
    }
}

private class IntMapEntry<V> {
    public var key:Int;
    public var value:V;

    public function new(key:Int, value:V) {
        this.key = key;
        this.value = value;
    }
}
