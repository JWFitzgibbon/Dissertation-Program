<@setoutput path=targetMainFile?default("")/>
<#if nedPackageName!="">package ${nedPackageName};</#if>
import inet.networklayer.configurator.ipv4.Ipv4NetworkConfigurator;
import inet.node.inet.WirelessHost;
import inet.physicallayer.ieee80211.packetlevel.Ieee80211ScalarRadioMedium;
<#if deviceType == "EchoGen1" || deviceType == "GoogleHome" || deviceType == "WyzeCamV3">
import inet.visualizer.integrated.IntegratedCanvasVisualizer;
import inet.node.inet.AdhocHost;
</#if>

network ${targetTypeName} {

    @display("bgb=6,4");
    @statistic[throughput](source=liveThroughput(destinationHost.app[0].packetReceived)/1000000; record=figure; targetFigure=panel.throughput; checkSignals=false);
    @statistic[numRcvdPk](source=count(destinationHost.app[0].packetReceived); record=figure; targetFigure=panel.numRcvdPkCounter; checkSignals=false);
    @figure[panel](type=panel; pos=1.5,0.1);
    @figure[panel.throughput](type=linearGauge; pos=250,50; size=250,30; minValue=0; maxValue=54; tickSize=6; label="Application level throughput [Mbps]");
    @figure[panel.numRcvdPkCounter](type=counter; pos=50,50; label="Packets received"; decimalPlaces=6);

     submodules:
     	<#if deviceType == "EchoGen1" || deviceType == "GoogleHome" || deviceType == "WyzeCamV3">
     	visualizer: IntegratedCanvasVisualizer {
            parameters:
            	@display("p=1.4274442,0.49377003");
        }
        ${deviceType}sourceHost : AdhocHost {
        <#else>
        ${deviceType}sourceHost : WirelessHost {
        </#if>
		<#if placement=="random">
            @display("p=${Math.random()*3.5},${Math.random()*2.3 + 1.4}");
		<#elseif placement=="none">
            @display("p=2.9167132,2.2853515");
		<#else>
		</#if>
         }
        destinationHost: WirelessHost {
            @display("p=2.9167132,0.49797544");
        }
        configurator: Ipv4NetworkConfigurator {
            @display("p=0.5,0.5");
        }
        radioMedium: Ieee80211ScalarRadioMedium {
            @display("p=0.5,1");
        }
}

