from search import *
from collections import defaultdict, deque, Counter
from pourproblem import *
from reporting import *


# print("Hello world!")

timing = {
    "Bono": 1,
    "Edge": 2,
    "Adam": 5,
    "Larry": 10
}


def sortingf(key):
    return timing[key]

class U2(Problem):
    """How to represent the state?
    Choice: state as a list of lists, indicating who is in which shore, and the presence of the torch
    Hence, the initial state is [["Bono", "Edge", "Adam", "Larry"], [], 1]
    The goal state will be [[], ["Bono", "Edge", "Adam", "Larry"], 0]"""

    def __init__(self, initial, goal):
        """Constructor"""
        self.initial = (tuple(sorted(initial[0], reverse=True, key=sortingf)),
                        tuple(sorted(initial[1], reverse=True, key=sortingf)), initial[2])
        self.goal = (tuple(sorted(goal[0], reverse=True, key=sortingf)),
                        tuple(sorted(goal[1], reverse=True, key=sortingf)),
                        goal[2])
        Problem.__init__(self, self.initial, self.goal)

    def path_cost(self, c, state1, action, state2):
        """Return the cost of a solution path that arrives at state2 from
        state1 via action, assuming cost c to get up to state1. If the problem
        is such that the path doesn't matter, this function will only look at
        state2.  If the path does matter, it will consider c and maybe state1
        and action. The default method costs 1 for every step in the path."""
        if len(action) == 2:
            return c + timing[action[0]]
        else:
            return c + timing[action]

    def actions(self, state):
        """The actions executable in this state."""
        if state[2]:
            pickUpFrom = state[0]
        else:
            pickUpFrom = state[1]
        result = [(first, second) for first in pickUpFrom for second in pickUpFrom if first != second and timing[first] > timing[second]] +\
                 [single for single in pickUpFrom]
        return result

    def result(self, state, action):
        """The state that results from executing this action in this state."""
        if state[2]:
            source = list(state[0])
            dest = list(state[1])
        else:
            source = list(state[1])
            dest = list(state[0])
        if len(action) == 2:
            for x in action:
                source.remove(x)
                dest.append(x)
        else:
            source.remove(action)
            dest.append(action)
        source.sort(reverse=True, key=sortingf)
        dest.sort(reverse=True, key=sortingf)
        if state[2]:
            return (tuple(source), tuple(dest), 0)
        else:
            return (tuple(dest), tuple(source), 1)

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
        thestate = node.state
        result = 0
        if len(thestate[0]) > 0:
            result += timing[thestate[0][0]]
        if len(thestate[0]) > 2:
            result += timing[thestate[0][2]]
        return result



u2=U2((("Bono", "Edge", "Adam", "Larry"), (), 1), ((), ("Bono", "Edge", "Adam", "Larry"), 0))
soln = astar_search(u2)
path = path_actions(soln)
print("Cost: ", soln.path_cost)
print(path)
path = path_states(soln)
print(path)

"""
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

"""