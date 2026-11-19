from reporting import *

class MC(Problem):
    def __init__(self, initial, goal):
        super().__init__(initial, goal)


    def isValid(self, state):
        m,c,b = state
        if (m>=c or m==0) and ((3-m)>=(3-c) or (3-m)==0):
            return True
        else:
            return False

    def actions(self, state):
        """
        (m, c, b). All three refer to the starting shore:

        m how many missionaries are on the starting shore.
        c: how many cannibals are on the starting shore.
        b: where the boat is. It is 1 if the boat is on the starting shore and 0 if it is on the other shore.

        An action is a pair (dm, dc): missionaries and cannibals on the boat.
        """
        m, c, b = state

        if not self.isValid(state):
            return []

        moves = []

        if b == 1:  
            if m > 0:
                moves.append((1, 0))
            if m > 1:
                moves.append((2, 0))
            if m > 0 and c > 0:
                moves.append((1, 1))
            if c > 0:
                moves.append((0, 1))
            if c > 1:
                moves.append((0, 2))
        else: 
            if (3-m) > 0:
                moves.append((1, 0))
            if (3-m) > 1:
                moves.append((2, 0))
            if (3-m) > 0 and (3-c) > 0:
                moves.append((1, 1))
            if (3-c) > 0:
                moves.append((0, 1))
            if (3-c) > 1:
                moves.append((0, 2))

        return moves

    def result(self, state, action):
        m,c,b = state

        m_moved, c_moved = action
        
        if b:
            return((m-m_moved, c-c_moved, 0))
        else:
            return((m+m_moved, c+c_moved, 1))

    def h(self, node):
        """Heuristic for A*: people still on the starting shore, minus 1 if the boat is there."""
        m, c, b = node.state
        return m + c - b


if __name__ == "__main__":
    mc1 = MC((3, 3, 1), (0, 0, 0))

    # One solution, in detail
    soln = breadth_first_graph_search(mc1)
    print("Actions:", path_actions(soln))
    print("Cost:", soln.path_cost)
    print("States:", path_states(soln))
    print()

    # Comparison of the strategies
    # depth_first_tree_search is left out: it loops forever on this problem
    report([
        breadth_first_tree_search,
        breadth_first_graph_search,
        depth_first_graph_search,
        astar_search,
    ], [mc1])
