package funk.collections.immutable;

import funk.Funk;
import funk.types.Function0;
import funk.types.Function1;
import haxe.ds.Option;
import funk.types.extensions.EnumValues;
import funk.types.extensions.Strings;

using funk.collections.Collection;
using funk.collections.immutable.List;

class ListUtil {

	public static function fill<T>(amount : Int) : Function1<Void -> T, List<T>> {
		return function (func : Void -> T) : List<T> {
			var list = Nil;
			while(--amount > -1) {
				list = list.prepend(func());
			}
			return list.reverse();
		};
	}

	public static function toList<T1, T2>(any : T1) : List<T2> {
		var result = Nil;
		switch(Type.typeof(any)) {
			case TObject:
				if (Std.is(any, Array)) {
					result = arrayToList(cast any);
				} else if (Std.is(any, String)) {
					result = stringToList(cast any);
				}
			case TClass(c):
				if (c == Array) {
					result = arrayToList(cast any);
				} else if (c == String) {
					result = stringToList(cast any);
				}
			case TEnum(e):
				if (e == ListType) {
					result = cast any;
				}
			default:
		}

		if (result.isEmpty()) {
			result = anyToList(cast any);
		}

		return cast result;
	}

	inline private static function anyToList<T>(any : T) : List<T> {
		return Nil.append(any);
	}

	inline private static function arrayToList<T>(array : Array<T>) : List<T> {
		var list = Nil;

		for (item in array) {
			list = list.append(item);
		}

		return list;
	}

	inline private static function stringToList<T>(string : String) : List<String> {
		var list = Nil;

		for (item in Strings.iterator(string)) {
			list = list.append(item);
		}

		return list;
	}
}
