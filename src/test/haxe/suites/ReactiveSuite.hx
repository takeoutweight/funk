package suites;

import massive.munit.TestSuite;

import funk.reactive.CollectionTest;
import funk.reactive.StreamTest;
import funk.reactive.StreamTypesTest;
import funk.reactive.StreamValuesTest;

import funk.reactive.events.EventsTest;
import funk.reactive.events.KeyboardEventsTest;
import funk.reactive.events.MouseEventsTest;
import funk.reactive.events.RenderEventsTest;

class ReactiveSuite extends TestSuite {

	public function new() {
		super();

		add(funk.reactive.CollectionTest);
		add(funk.reactive.StreamTest);
		add(funk.reactive.StreamTypesTest);
		add(funk.reactive.StreamValuesTest);

		add(funk.reactive.events.EventsTest);
		add(funk.reactive.events.KeyboardEventsTest);
		add(funk.reactive.events.MouseEventsTest);
		add(funk.reactive.events.RenderEventsTest);
	}
}
