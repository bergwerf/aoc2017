import 'utils.dart';

void main() {
  final data = read('25.txt');
  final re1 = new RegExp(r'Begin in state ([A-Z]+)');
  final re2 = new RegExp(r'Perform a diagnostic checksum after ([0-9]+) steps');
  final re3 = new RegExp(r'In state ([A-Z]+):\s+'
      r'If the current value is 0:\s+'
      r'- Write the value ([0-1])\.\s+'
      r'- Move one slot to the ((?:left|right))\.\s+'
      r'- Continue with state ([A-Z]+)\.\s+'
      r'If the current value is 1:\s+'
      r'- Write the value ([0-1])\.\s+'
      r'- Move one slot to the ((?:left|right))\.\s+'
      r'- Continue with state ([A-Z]+)\.');

  final initState = re1.firstMatch(data).group(1);
  final diagnostics = int.parse(re2.firstMatch(data).group(1));
  final instructions = new Map<String, Map<bool, Instruction>>();
  for (final m in re3.allMatches(data)) {
    Instruction getInstruction(int offset) {
      final write = m.group(offset + 0) == '1';
      final move = m.group(offset + 1) == 'left' ? -1 : 1;
      final next = m.group(offset + 2);
      return new Instruction(write, move, next);
    }

    final state = m.group(1);
    instructions[state] = {false: getInstruction(2), true: getInstruction(5)};
  }

  print('Begin in state $initState.');
  print('Perform a diagnostic checksum after $diagnostics steps.');
  instructions.forEach((state, what) {
    print('\nIn state $state:');
    print('  If the current value is 0:\n${what[false]}');
    print('  If the current value is 1:\n${what[true]}');
  });

  final tape = new List<bool>();
  tape.add(false);
  var zeroIndex = 0, ptr = 0, state = initState;
  for (var i = 0; i < diagnostics; i++) {
    final ins = instructions[state][tape[zeroIndex + ptr]];
    tape[zeroIndex + ptr] = ins.write;
    ptr += ins.move;
    state = ins.next;

    // Resize tape.
    while (zeroIndex + ptr < 0) {
      tape.insert(0, false);
      zeroIndex++;
    }
    while (zeroIndex + ptr >= tape.length) {
      tape.add(false);
    }
  }

  print('\n${tape.where((v) => v).length}');
}

class Instruction {
  final bool write;
  final int move;
  final String next;

  Instruction(this.write, this.move, this.next);

  String toString() => //
      '    - Write the value ${write ? '1' : '0'}.\n'
      '    - Move one slot to the ${move < 0 ? 'left' : 'right'}.\n'
      '    - Continue with state $next.';
}
