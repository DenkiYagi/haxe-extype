package extype;

import extype.Set.ISet;
#if js
import js.Syntax;
import js.lib.Set in JsSet;
import extype.js.IteratorAdapter;
#else
import haxe.ds.ObjectMap;
import extype.LinkedNodeList;
#end

/**
    Represents a set of object values.
    You can iterate through the values of a set in insertion order.
**/
class ObjectSet<T:{}> implements ISet<T> {
    #if js
    final set:JsSet<T>;
    #else
    final map:ObjectMap<T, LinkedNode<T>>;
    final list:LinkedNodeList<T>;
    #end

    /**
        Returns the number of values in this set.
    **/
    public var length(get, never):Int;

    public function new() {
        #if js
        this.set = new JsSet();
        #else
        this.map = new ObjectMap();
        this.list = new LinkedNodeList();
        #end
    }

    /**
        Adds a specified value to this set.
    **/
    public function add(value:T):Void {
        #if js
        set.add(value);
        #else
        if (!map.exists(value)) {
            addInternal(value);
        }
        #end
    }

    /**
        Returns true if this set has a specified value, false otherwise.
    **/
    public function exists(value:T):Bool {
        #if js
        return set.has(value);
        #else
        return map.exists(value);
        #end
    }

    /**
        Removes a specified value to this set and returns true if such a value existed, false otherwise.
    **/
    public function remove(value:T):Bool {
        #if js
        return set.delete(value);
        #else
        return if (map.exists(value)) {
            final node = map.get(value);
            map.remove(value);
            list.remove(node);
            true;
        } else {
            false;
        }
        #end
    }

    /**
        Returns an Iterator over the values of this set.
    **/
    #if js
    public function iterator():IteratorAdapter<T> {
        return new IteratorAdapter(set.values());
    }
    #else
    public function iterator():LinkedNodeIterator<T> {
        return list.iterator();
    }
    #end

    /**
        Returns a new shallow copy of this set.
    **/
    public function copy():ObjectSet<T> {
        final copy = new ObjectSet();
        for (x in inline iterator()) {
            #if js
            copy.add(x);
            #else
            copy.addInternal(x);
            #end
        }
        return copy;
    }

    /**
        Reterns a new array that contains the values in this set.
    **/
    public function array():Array<T> {
        #if js
        return Syntax.code("Array.from({0})", set);
        #else
        final array = [];
        iter(array.push);
        return array;
        #end
    }

    /**
        Returns a String representation of this set.
    **/
    public function toString():String {
        final buff = [];
        iter(x -> buff.push(Std.string(x)));
        return '{${buff.join(",")}}';
    }

    inline function iter(fn:(value:T) -> Void):Void {
        #if js
        set.forEach((x, _, _) -> fn(x));
        #else
        list.iter(fn);
        #end
    }

    inline function get_length():Int {
        #if js
        return set.size;
        #else
        return list.length;
        #end
    }

    #if !js
    inline function addInternal(value:T):Void {
        map.set(value, list.add(value));
    }
    #end
}