from search import *
from reporting import path_states, path_actions

TIMINGS = [1, 2, 5, 10]
MAX_TIME = 17


class InvalidActionException(Exception):
    pass


class InvalidStateException(Exception):
    pass


class State:

    def __init__(self, left_side: tuple[bool, bool, bool, bool], right_side: tuple[bool, bool, bool, bool],
                 torch_on_left: bool):

        for i in range(len(left_side)):
            if left_side[i] == right_side[i]:
                raise InvalidStateException("A person must be in exact one position (either left or right)")

        self._left_side = left_side
        self._right_side = right_side
        self._torch_on_left = torch_on_left

    @property
    def value(self) -> tuple[tuple, tuple, bool]:
        return self._left_side, self._right_side, self._torch_on_left

    @property
    def left(self) -> tuple[bool, bool, bool, bool]:
        return self._left_side

    @property
    def right(self) -> tuple[bool, bool, bool, bool]:
        return self._right_side

    @property
    def torch_on_left(self) -> bool:
        return self._torch_on_left

    def __lt__(self, other):
        return self.value < other.value


class Action:

    def __init__(self, people: tuple, to_right: bool):

        if len(people) > 2:
            raise InvalidActionException("An action can take 2 people at most")

        if len(people) == 0:
            raise InvalidActionException("An action must take at least 1 person")

        if len(people) == 2:
            if people[0] == people[1]:
                raise InvalidActionException("The people involved in an action must be different")
            if people[0] > people[1]:
                people = tuple([people[1], people[0]])

        self._people = people
        self._to_right = to_right

    @property
    def value(self) -> tuple[tuple, bool]:
        return self._people, self._to_right

    @property
    def people(self) -> tuple:
        return self._people

    @property
    def to_right(self) -> bool:
        return self._to_right


class U2Problem(Problem):

    def __init__(self, initial_state: State, goal_state: State, timings: list[int], max_time: int):

        super().__init__(initial_state, goal_state)

        self._timings = timings
        self._max_time = max_time

    def path_cost(self, c: int, state1: State, action: Action, state2: State) -> int:

        people = action.people
        group_timing = self._timings[people[-1]]
        cost = c + group_timing

        return cost

    def actions(self, state: State) -> list[Action]:

        valid_actions: list[Action] = []

        if state.torch_on_left:
            left_side = state.left
            for i in range(len(left_side)-1):
                for j in range(i+1, len(left_side)):
                    if left_side[i] and left_side[j]:
                        action = Action((i, j), True)
                        valid_actions.append(action)

        else:
            right_side = state.right
            for i in range(len(right_side)):
                if right_side[i]:
                    action = Action((i,), False)
                    valid_actions.append(action)

        return valid_actions

    def result(self, state: State, action: Action) -> State:

        people = action.people

        left_side = state.left
        right_side = state.right

        new_left_side = list(left_side)
        new_right_side = list(right_side)
        new_direction = not state.torch_on_left

        for person in people:
            new_left_side[person] = not left_side[person]
            new_right_side[person] = not right_side[person]

        new_state = State(tuple(new_left_side), tuple(new_right_side), new_direction)

        return new_state

    def goal_test(self, state: State) -> bool:
        return state.value == self.goal.value

    def h(self, node: Node) -> int:

        state: State = node.state

        left_side = state.left
        max_1 = 0
        max_2 = 0

        for i in range(len(left_side)-1, -1, -1):
            if left_side[i]:
                if max_1 == 0:
                    max_1 = self._timings[i]
                else:
                    max_2 = self._timings[i]
                    break

        heuristic = max_1 + max_2

        return heuristic


if __name__ == '__main__':

    initial = State((True, True, True, True), (False, False, False, False), True)
    goal = State((False, False, False, False), (True, True, True, True), False)

    problem = U2Problem(initial, goal, TIMINGS, MAX_TIME)

    solution = astar_search(problem)

    print("Cost: ", solution.path_cost)

    actions_path = path_actions(solution)
    actions_path = [action.value for action in actions_path]
    print("Actions path:", actions_path)
    print()

    states_path = path_states(solution)
    states_path = [state.value for state in states_path]
    print("States path: ", states_path)
