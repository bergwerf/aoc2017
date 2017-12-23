import 'utils.dart';

class ThreadState {
  final bool paused;
  final int pointer;
  ThreadState(this.paused, this.pointer);
}

void main() {
  final List<List<String>> data =
      read('18.txt').split('\n').map((l) => l.split(' ').toList()).toList();

  final mem = new Map<String, int>();
  final queue = new List<int>();
  for (var i = 0; i < data.length;) {
    final state = process(mem, data[i], queue, queue, i, 1);
    i = state.pointer;
    if (state.paused) {
      break;
    }
  }

  var ptr0 = 0, ptr1 = 0;
  final mem0 = <String, int>{'p': 0};
  final mem1 = <String, int>{'p': 1};
  final queue0 = new List<int>();
  final queue1 = new List<int>();
  var deadlock = false, sendCount = 0;
  while (!deadlock) {
    final state0 = process(mem0, data[ptr0], queue1, queue0, ptr0, 2);
    final queue0l = queue0.length;
    final state1 = process(mem1, data[ptr1], queue0, queue1, ptr1, 2);

    // Count sends by process 1.
    sendCount += queue0.length - queue0l;

    ptr0 = state0.pointer;
    ptr1 = state1.pointer;
    deadlock = state0.paused && state1.paused;
  }
  print(sendCount);
}

ThreadState process(Map<String, int> mem, List<String> ins, List<int> sndQueue,
    List<int> rcvQueue, int ptr, int version) {
  // utilities
  int parse(String expr) => int.parse(expr, onError: (reg) => mem[reg] ?? 0);
  void put(String reg, int v) => mem[reg] = v;

  final op = ins[0];
  final reg = ins[1];
  switch (op) {
    case 'set':
      put(reg, parse(ins[2]));
      break;
    case 'add':
      put(reg, parse(reg) + parse(ins[2]));
      break;
    case 'sub':
      put(reg, parse(reg) - parse(ins[2]));
      break;
    case 'mul':
      put(reg, parse(reg) * parse(ins[2]));
      break;
    case 'mod':
      put(reg, parse(reg) % parse(ins[2]));
      break;
    case 'jnz':
      ptr += parse(reg) != 0 ? parse(ins[2]) - 1 : 0;
      break;
    case 'jgz':
      ptr += parse(reg) > 0 ? parse(ins[2]) - 1 : 0;
      break;
    case 'snd':
      sndQueue.add(parse(reg));
      break;
    case 'rcv':
      if (version == 1) {
        if (parse(reg) != 0) {
          print(rcvQueue.last);
          return new ThreadState(true, ptr); // terminate
        }
      } else if (version == 2) {
        if (rcvQueue.isNotEmpty) {
          put(reg, rcvQueue.removeAt(0));
        } else {
          return new ThreadState(true, ptr); // wait
        }
      }
  }

  // Move program pointer forward.
  return new ThreadState(false, ptr + 1);
}
