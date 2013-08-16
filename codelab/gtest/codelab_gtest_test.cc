#include "third_party/gtest-1.6.0/include/gtest/gtest.h"

class Testing {
 public:
  Testing(int additive) {
    add = additive;
  }
  int plus(int a) {
    return add + a;
  }
 private:
  int add;
};

TEST(test_testing, add3) {
  Testing t(3);
  ASSERT_EQ(4 + 3, t.plus(4));
}
