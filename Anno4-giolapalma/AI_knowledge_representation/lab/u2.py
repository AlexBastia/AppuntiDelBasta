from notebooks.game_theory import election
from reporting import *

# Crossing time (in minutes) of each member of the band.
TIMES = {"Bono": 1, "Edge": 2, "Adam": 5, "Larry": 10}


class U2(Problem):
    """U2 bridge problem.

    State: tuple (people on the starting shore, people on the far shore, torch)
      - torch is 1 if the torch is on the starting shore, 0 otherwise
      - every shore must be a tuple, in a fixed (canonical) order
      - the state must be hashable: no lists inside!

    Action: who crosses (a pair when going forward, one person when coming back).
    """

    def __init__(self, initial, goal):
        super().__init__(initial, goal)


    def actions(self, state):
        """Actions applicable in this state.


        TODO: torch on the starting shore -> every possible pair from that shore
              torch on the far shore      -> every single person from that shore

              Ture means: ->
              False means: <-
        """
        actions = []

        here, there, t = state

        if t:
            return list(combinations(here, 2))
        else:
            return [(person,) for person in there]        
        return actions

    def result(self, state, action):
        """New state after applying the action; the received state is not modified."""
        here, there, t = state

        if t:   # torch on the starting shore: the people of the action cross forward
            new_here = tuple(p for p in here if p not in action)
            new_there = tuple(sorted(there + action, key=TIMES.get))
            return (new_here, new_there, 0)
        else:   # torch on the far shore: the person of the action comes back
            new_there = tuple(p for p in there if p not in action)
            new_here = tuple(sorted(here + action, key=TIMES.get))
            return (new_here, new_there, 1)
    def goal_test(self, state):
        """TODO: optional, the default compares state with self.goal.
        Make sure the goal has the same shape (tuples) as your states."""
        pass

    def path_cost(self, c, state1, action, state2):
        """Cost up to state2.

        TODO: c + time of the move
              (the slower of the pair going forward, the person alone coming back)
        """
        pass

    def h(self, node):
        """Heuristic for A*; the state is node.state.

        TODO: group the people still on the starting shore in couples
              (the two slowest together, then the others), every group
              takes the time of its slowest member, h = sum of those times.
              Is it admissible?
        """
        pass


if __name__ == "__main__":
    # TODO: build the initial and goal states (as tuples)
    # u2 = U2(initial, goal)

    # TODO: solve with astar_search and print path_actions, path_cost, path_states
    # TODO: check that the cost is within the 17 minutes

    # TODO: compare the strategies with report([...], [u2])
    pass
