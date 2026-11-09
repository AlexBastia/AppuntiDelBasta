import math

from search import *
from reporting import report, path_states, path_actions

PROBLEM_SIZE = 3


class InvalidActionException(Exception):
    pass


class MissionariesCannibalsProblem(Problem):

    def __init__(self, n_people: int, initial_state: tuple[int, int, bool], goal_state: tuple[int, int, bool]):

        super().__init__(initial_state, goal_state)

        self._n_people = n_people

    def is_failure_state(self, state: tuple[int, int, bool]) -> bool:

        missionaries_l, cannibals_l, boat_on_left = state
        missionaries_r = self._n_people - missionaries_l
        cannibals_r = self._n_people - cannibals_l

        return 0 < missionaries_l < cannibals_l or 0 < missionaries_r < cannibals_r

    def actions(self, state: tuple[int, int, bool]) -> list[str]:

        if self.is_failure_state(state):
            return []

        missionaries_l, cannibals_l, boat_on_left = state
        missionaries_r = self._n_people - missionaries_l
        cannibals_r = self._n_people - cannibals_l

        valid_actions = []

        if boat_on_left:
            if missionaries_l > 0 and cannibals_l > 0:
                valid_actions.append("MC->")
            if missionaries_l > 1:
                valid_actions.append("MM->")
            if cannibals_l > 1:
                valid_actions.append("CC->")
            if missionaries_l > 0:
                valid_actions.append("M->")
            if cannibals_l > 0:
                valid_actions.append("C->")

        else:
            if missionaries_r > 0 and cannibals_r > 0:
                valid_actions.append("<-MC")
            if missionaries_r > 1:
                valid_actions.append("<-MM")
            if cannibals_r > 1:
                valid_actions.append("<-CC")
            if missionaries_r > 0:
                valid_actions.append("<-M")
            if cannibals_r > 0:
                valid_actions.append("<-C")

        return valid_actions

    def result(self, state: tuple[int, int, bool], action: str) -> tuple[int, int, bool]:

        missionaries_l, cannibals_l, boat_on_left = state

        if action == 'MC->':
            new_state = (missionaries_l - 1, cannibals_l - 1, False)
        elif action == 'MM->':
            new_state = (missionaries_l - 2, cannibals_l, False)
        elif action == 'CC->':
            new_state = (missionaries_l, cannibals_l - 2, False)
        elif action == 'M->':
            new_state = (missionaries_l - 1, cannibals_l, False)
        elif action == 'C->':
            new_state = (missionaries_l, cannibals_l - 1, False)
        elif action == '<-MC':
            new_state = (missionaries_l + 1, cannibals_l + 1, True)
        elif action == '<-MM':
            new_state = (missionaries_l + 2, cannibals_l, True)
        elif action == '<-CC':
            new_state = (missionaries_l, cannibals_l + 2, True)
        elif action == '<-M':
            new_state = (missionaries_l + 1, cannibals_l, True)
        elif action == '<-C':
            new_state = (missionaries_l, cannibals_l + 1, True)

        else:
            raise InvalidActionException("The action " + action + " is invalid")

        return new_state

    def h(self, node: Node) -> int:

        missionaries_l, cannibals_l, boat_on_left = node.state

        heuristic = math.ceil((missionaries_l + cannibals_l) / 2)

        return heuristic


if __name__ == '__main__':

    initial = (PROBLEM_SIZE, PROBLEM_SIZE, True)
    goal = (0, 0, False)

    problem = MissionariesCannibalsProblem(PROBLEM_SIZE, initial, goal)

    solution = breadth_first_tree_search(problem)

    actions_path = path_actions(solution)
    print("Actions path:", actions_path)
    print()

    states_path = path_states(solution)
    print("States path: ", states_path)
    print()

    print("Report:")
    report([
        breadth_first_tree_search,
        breadth_first_graph_search,
        depth_first_graph_search,
        astar_search
    ],
        [problem])
