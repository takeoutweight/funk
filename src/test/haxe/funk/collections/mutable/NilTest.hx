package funk.collections.mutable;

import funk.collections.NilTestBase;
import funk.collections.mutable.ListUtil;
import funk.collections.mutable.Nil;

using funk.collections.mutable.ListUtil;
using funk.collections.mutable.Nil;

class NilTest extends NilTestBase {

	@Before
	public function setup():Void {
		actual = Nil.list();
		expected = Nil.list();
		other = Nil.list();
		filledList = [1, 2, 3, 4].toList();
	}

	@After
	public function tearDown():Void {
		actual = null;
		expected = null;
		other = null;
		filledList = null;
	}
}
