void main() {
  var n1 = 93 * 100 + 100000;
  var n2 = n1 + 17000;
  //var g = 0;
  var h = 0;

  // n2 > n1
  for (var b = n1, c = n2; b <= c; b += 17) {
    // This is an integer factorization problem:
    // If b can be factorized (i.e. is not a prime), then
    // h is incremented.
    for (var f1 = 2; f1 < b; f1++) {
      if (b % f1 == 0) {
        // Is a composite number.
        h++;
        break;
      }
    }

    /*
    // Note that b is a positive number.
    for (var d = 2; d < b; d++) {
      for (var e = 2; e < b; e++) {
        if (d * e == b) {
          h++;
        }
      }
    }
    */

    /*
    var f = 1;
    var d = 2;
    do {
      // Three versions of the same code:
      // version 1:
      var e = 2;
      do {
        g = d * e - b;
        if (g == 0) {
          f = 0;
        }
        e++;
        g = e - b;
      } while (g != 0);
      // verion 2:
      for (var e = 2; e - b != 0; e++) {
        if (d * e - b == 0) {
          f = 0;
        }
      }

      d++;
      g = d - b;
    } while (g != 0);

    if (f == 0) {
      h++;
    }
    */

    //g = b - c;
    //b += 17;
  }

  print(h);
}
