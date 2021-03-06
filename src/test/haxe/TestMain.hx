import massive.munit.client.PrintClient;
import massive.munit.client.RichPrintClient;
import massive.munit.client.HTTPClient;
import massive.munit.client.JUnitReportClient;
import massive.munit.TestRunner;
import massive.munit.Assert;

import suites.ActorsSuite;
import suites.ArrowsSuite;
import suites.DataStructuresSuite;
import suites.FuturesSuite;
import suites.IocSuite;
import suites.IoSuite;
import suites.LoggingSuite;
import suites.NetSuite;
import suites.ReactivesSuite;
import suites.SignalsSuite;
import suites.TypesSuite;

#if js
import js.Lib;
#end


/**
 * Auto generated Test Application.
 * Refer to munit command line tool for more information (haxelib run munit)
 */

class TestMain {

    #if neko
        private var reporting : Bool;
        private var reportFinished : Bool;
    #end

    static function main(){ new TestMain(); }

    public function new() {

        var suites = new Array<Class<massive.munit.TestSuite>>();

        suites.push(ActorsSuite);
        suites.push(ArrowsSuite);
        suites.push(DataStructuresSuite);
        suites.push(FuturesSuite);
        suites.push(IocSuite);
        suites.push(IoSuite);
        suites.push(LoggingSuite);
        suites.push(NetSuite);
        suites.push(ReactivesSuite);
        suites.push(SignalsSuite);
        suites.push(TypesSuite);

        #if MCOVER
            var client = new mcover.coverage.munit.client.MCoverPrintClient();
        #else
            var client = new RichPrintClient();
        #end

        var runner:TestRunner = new TestRunner(client);

        #if ciserver
        runner.addResultClient(new HTTPClient(new JUnitReportClient()));
        #end

        runner.completionHandler = completionHandler;
        runner.run(suites);
    }

    /*
        updates the background color and closes the current browser
        for flash and html targets (useful for continous integration servers)
    */
    private function completionHandler(successful : Bool) : Void {
        trace('Assertions made : ${Assert.assertionCount}');
        try {
            #if flash
                flash.external.ExternalInterface.call("testResult", successful);
            #elseif js
                js.Lib.eval("testResult(" + successful + ");");
            #elseif neko
                Sys.exit(successful ? 0 : 1);
            #end
        } catch (e:Dynamic) {
            // if run from outside browser can get error which we can ignore
        }
    }
}
