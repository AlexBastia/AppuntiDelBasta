from search import *
from collections import defaultdict, deque, Counter
from reporting import *




class PourProblem(Problem):
    """Problem about pouring water between jugs to achieve some water level.
    Each state is a tuples of water levels. In the initialization, also provide a tuple of
    jug sizes, e.g. PourProblem(initial=(0, 0), goal=4, sizes=(5, 3)),
    which means two jugs of sizes 5 and 3, initially both empty, with the goal
    of getting a level of 4 in either jug."""

    def __init__(self, initial, goal, sizes):
        """Constructor"""
        self.initial = initial
        self.goal = goal
        self.sizes = sizes
        Problem.__init__(self, initial, goal)

    def actions(self, state):
        """The actions executable in this state."""
        jugs = range(len(state))
        return ([('Fill', i) for i in jugs if state[i] < self.sizes[i]] +
                [('Dump', i) for i in jugs if state[i]] +
                [('Pour', i, j) for i in jugs if state[i] for j in jugs if i != j])

    def result(self, state, action):
        """The state that results from executing this action in this state."""
        result = list(state)
        act, i, *_ = action
        if act == 'Fill':  # Fill i to capacity
            result[i] = self.sizes[i]
        elif act == 'Dump':  # Empty i
            result[i] = 0
        elif act == 'Pour':  # Pour from i into j
            j = action[2]
            amount = min(state[i], self.sizes[j] - state[j])
            result[i] -= amount
            result[j] += amount
        return tuple(result)

    # def is_goal(self, state):
    #     """True if the goal level is in any one of the jugs."""
    #     return self.goal in state

    def goal_test(self, state):
        """Return True if the state is a goal. The default method compares the
        state to self.goal or checks for state in self.goal if it is a
        list, as specified in the constructor. Override this method if
        checking against a single self.goal is not enough."""
        return self.goal in state




"""
p1 = PourProblem((1, 1, 1), 13, sizes=(2, 16, 32))
p2 = PourProblem((0, 0, 0), 21, sizes=(8, 11, 31))
p3 = PourProblem((0, 0),     8, sizes=(7, 9))
p4 = PourProblem((0, 0, 0), 21, sizes=(8, 11, 31))
p5 = PourProblem((0, 0),     4, sizes=(3, 5))
p6 = PourProblem((0, 0),     4, sizes=(4, 5))
"""



"""
soln = breadth_first_graph_search(p3)
print("Done!!!")
path = path_actions(soln)
print(path)
path = path_states(soln)
print(path)

report([breadth_first_graph_search], [p1, p3, p6])
"""
