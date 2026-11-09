from search import *
from collections import defaultdict, deque, Counter
from pourproblem import *
from reporting import *


# print("Hello world!")


class MC(Problem):
    """How to represent the state?
    Choice: state as a tuple, indicating
    the number of missionars, the number of cannibals, and the presence of the boat on the starting river
    Hence, the initial state is (3, 3, 1)
    The goal state will be (0, 0, 0)"""

    def __init__(self, initial, goal):
        """Constructor"""
        self.initial = initial
        self.goal = goal
        Problem.__init__(self, initial, goal)

    def isValid(self, state):
        m, c, *_ = state
        if (m>0 and c > m) or ((3-m)>0 and (3-c) > (3-m)):
            return False
        else:
            return True

    def actions(self, state):
        """The actions executable in this state."""
        if not self.isValid(state):
            return []

        m, c, b = state
        result = []
        if m > 0 and c > 0 and b:
            result.append('MC->')
        if m > 1 and b:
            result.append('MM->')
        if c > 1 and b:
            result.append('CC->')
        if m > 0 and b:
            result.append('M->')
        if c > 0 and b:
            result.append('C->')
        if (3-m) > 0 and (3-c) > 0 and not b:
            result.append('<-MC')
        if (3-m) > 1 and not b:
            result.append('<-MM')
        if (3-c) > 1 and not b:
            result.append('<-CC')
        if (3-m) > 0 and not b:
            result.append('<-M')
        if (3-c) > 0 and not b:
            result.append('<-C')
        return result

    def result(self, state, action):
        """The state that results from executing this action in this state."""
        m, c, b = state
        if action == 'MC->':
            return (m - 1, c - 1, 0)
        elif action == 'MM->':
            return (m-2, c, 0)
        elif action == 'CC->':
            return (m, c-2, 0)
        elif action == 'M->':
            return (m-1, c, 0)
        elif action == 'C->':
            return (m, c-1, 0)
        elif action == '<-MC':
            return (m+1, c+1, 1)
        elif action == '<-MM':
            return (m+2, c, 1)
        elif action == '<-CC':
            return (m, c+2, 1)
        elif action == '<-M':
            return (m+1, c, 1)
        elif action == '<-C':
            return (m, c+1, 1)
        else:
            print("ERRORE!!!")
            return None


    def goal_test(self, state):
        """Return True if the state is a goal. The default method compares the
        state to self.goal or checks for state in self.goal if it is a
        list, as specified in the constructor. Override this method if
        checking against a single self.goal is not enough."""
        if isinstance(self.goal, list):
            return is_in(state, self.goal)
        else:
            return state == self.goal

    def h(self, node):
        m, c,  b = node.state
        return m + c - b





mc1 = MC((3, 3, 1), (0, 0, 0))
soln = breadth_first_tree_search(mc1)
# print("Done!!!")
path = path_actions(soln)
print(path)
path = path_states(soln)
print(path)

report([
    breadth_first_tree_search,
    breadth_first_graph_search,
    # depth_first_tree_search,
    depth_first_graph_search,
    astar_search
    ],
    [mc1])

