[General]
network = ${targetTypeName}
sim-time-limit = ${simTime}s

# Sets Address Resolution Protocol (ARP) to global, meaning devices in the network don't have to resolve themselves
*.*Host*.ipv4.arp.typename = "GlobalArp"
# Network management type is Ad-hoc, meaning devices have to communicate with themselves instead of sending to an access point
# Infrastructure mode with an access point is possible, but Ad-hoc puts more strain on the devices
*.*Host*.wlan[*].mgmt.typename = "Ieee80211MgmtAdhoc"
# 802.11 Management Base throws 'handleCommand()' runtime error when not specifically set to its default "". The reasoning is enigmatic
*.*Host*.wlan[*].agent.typename = ""
*.*Host*.wlan[*].opMode = "${wifiStandard}"
<#if wifiStandard=="a" || wifiStandard=="g(erp)" || wifiStandard=="g(mixed)">
	<#assign bitrate = 54>
<#elseif wifiStandard=="b">
	<#assign bitrate = 11>
<#elseif wifiStandard=="n(mixed-2.4Ghz)">
	<#assign bitrate = 450>
# 802.11n standard supports MIMO, ignoring spatial stream interference is required for the simulation to run correctly
*.radioMedium.**.ignorePartialInterference = true
<#elseif wifiStandard=="ac">
	<#assign bitrate = 1300>
# 802.11ac standard supports MIMO, ignoring spatial stream interference is required for the simulation to run correctly
*.radioMedium.**.ignorePartialInterference = true
</#if>
*.*Host*.wlan[*].bitrate = ${bitrate}Mbps
*.*Host*.wlan[*].mac.dcf.originatorMacDataService.fragmentationPolicy.fragmentationThreshold = 2304B + 28B
*.*Host*.wlan[*].radio.separateReceptionParts = true
*.*Host*.wlan[*].radio.separateTransmissionParts = true

<#if deviceType == "EchoGen1">
*.visualizer.energyStorageVisualizer.displayEnergyStorages = true
*.*sourceHost*.hasStatus = true
*.*sourceHost*.energyStorage.typename = "SimpleEpEnergyStorage"
*.*sourceHost*.wlan[*].radio.energyConsumer.typename = "StateBasedEpEnergyConsumer"
*.*sourceHost*.wlan[*].radio.energyConsumer.transmitterTransmittingPowerConsumption = 3600mW
*.*sourceHost*.energyManagement.typename = "SimpleEpEnergyManagement"
*.*sourceHost*.energyStorage.nominalCapacity = 8.25J
*.*sourceHost*.energyManagement.nodeShutdownCapacity = 0.4J
*.*sourceHost*.energyManagement.nodeStartCapacity = energyManagement.nodeShutdownCapacity + 0.1J
*.*sourceHost*.energyGenerator.typename = "AlternatingEpEnergyGenerator"
*.*sourceHost*.energyGenerator.powerGeneration = 8250mW
*.*sourceHost*.energyGenerator.sleepInterval = 0s
*.*sourceHost*.energyGenerator.generationInterval = 1s
<#elseif deviceType == "GoogleHome">
*.visualizer.energyStorageVisualizer.displayEnergyStorages = true
*.*sourceHost*.hasStatus = true
*.*sourceHost*.energyStorage.typename = "SimpleEpEnergyStorage"
*.*sourceHost*.wlan[*].radio.energyConsumer.typename = "StateBasedEpEnergyConsumer"
*.*sourceHost*.wlan[*].radio.energyConsumer.transmitterTransmittingPowerConsumption = 2200mW
*.*sourceHost*.energyManagement.typename = "SimpleEpEnergyManagement"
*.*sourceHost*.energyStorage.nominalCapacity = 8.25J
*.*sourceHost*.energyManagement.nodeShutdownCapacity = 1.8J
*.*sourceHost*.energyManagement.nodeStartCapacity = energyManagement.nodeShutdownCapacity + 0.1J
*.*sourceHost*.energyGenerator.typename = "AlternatingEpEnergyGenerator"
*.*sourceHost*.energyGenerator.powerGeneration = 8250mW
*.*sourceHost*.energyGenerator.sleepInterval = 0s
*.*sourceHost*.energyGenerator.generationInterval = 1s
<#elseif deviceType == "WyzeCamV3">
*.visualizer.energyStorageVisualizer.displayEnergyStorages = true
*.*sourceHost*.hasStatus = true
*.*sourceHost*.energyStorage.typename = "SimpleEpEnergyStorage"
*.*sourceHost*.wlan[*].radio.energyConsumer.typename = "StateBasedEpEnergyConsumer"
*.*sourceHost*.wlan[*].radio.energyConsumer.transmitterTransmittingPowerConsumption = 4000mW
*.*sourceHost*.energyManagement.typename = "SimpleEpEnergyManagement"
*.*sourceHost*.energyStorage.nominalCapacity = 5.00J
*.*sourceHost*.energyManagement.nodeShutdownCapacity = 1.9J
*.*sourceHost*.energyManagement.nodeStartCapacity = energyManagement.nodeShutdownCapacity + 0.1J
*.*sourceHost*.energyGenerator.typename = "AlternatingEpEnergyGenerator"
*.*sourceHost*.energyGenerator.powerGeneration = 5000mW
*.*sourceHost*.energyGenerator.sleepInterval = 0s
*.*sourceHost*.energyGenerator.generationInterval = 1s
</#if>

*.*sourceHost*.numApps = 1
*.*sourceHost*.app[0].typename = "UdpBasicApp"
*.*sourceHost*.app[*].destAddresses = "destinationHost"
*.*sourceHost*.app[*].destPort = 5000
*.*sourceHost*.app[*].packetName = "UDPData-"
*.*sourceHost*.app[*].startTime = 0s
*.*sourceHost*.app[*].messageLength = $//{packetLength = 100, 1000, 2268}byte	# TODO: Remove all '//' between $ and { when simulation is built
*.*sourceHost*.app[*].sendInterval = $//{packetLength} * 8 / ${bitrate} * 1us	# FTL files treat $ {} as its own variables instead of INI variables
																				# So they need to be fixed afterwards to prevent compilation errors
*.destinationHost.numApps = 1
*.destinationHost.app[0].typename = "UdpSink"
*.destinationHost.app[*].localPort = 5000