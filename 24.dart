import 'utils.dart';

class Bridge {
  int strengh = 0, outSocket = 0;
  final connectors = new Set<int>();
}

void main() {
  final data = read('24.txt')
      .split('\n')
      .map((line) => line.split('/').map(int.parse).toList())
      .toList();

  final lookup = new Map<int, List<int>>();
  for (var i = 0; i < data.length; i++) {
    final port = data[i];
    lookup.putIfAbsent(port[0], () => []);
    lookup.putIfAbsent(port[1], () => []);
    lookup[port[0]].add(i);
    lookup[port[1]].add(i);
  }

  final bridges = findBridges(data, lookup, new Bridge());
  bridges.sort((a, b) => a.strengh - b.strengh); // Sort by weight.
  print(bridges.last.strengh);

  bridges.sort((a, b) {
    final lengthFactor = a.connectors.length - b.connectors.length;
    return lengthFactor == 0 ? a.strengh - b.strengh : lengthFactor;
  }); // Sort by length and then weight.
  print(bridges.last.strengh);
}

List<Bridge> findBridges(
    List<List<int>> ports, Map<int, List<int>> lookup, Bridge bridge) {
  final list = new List<Bridge>();
  list.add(bridge);

  for (final i in ((lookup[bridge.outSocket] ?? <int>[]).toSet())
      .difference(bridge.connectors)) {
    final p = ports[i];
    final outSocket = p[0] == bridge.outSocket ? p[1] : p[0];
    final newBridge = addConnector(bridge, i, outSocket);
    final bridges = findBridges(ports, lookup, newBridge);
    list.addAll(bridges);
  }

  return list;
}

Bridge addConnector(Bridge src, int connectorId, int outSocket) {
  final bridge = new Bridge();
  bridge.strengh = src.strengh + src.outSocket + outSocket;
  bridge.connectors
    ..addAll(src.connectors)
    ..add(connectorId);
  bridge.outSocket = outSocket;
  return bridge;
}
