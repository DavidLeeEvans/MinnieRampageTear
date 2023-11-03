package dex.util;

/**
 * Simple state machine, where states and transitions are defined in `Int` abstracts.
 *
 * @param S the states enum
 * @param T the transitions enum
 */
class StateMachine<S: Int, T: Int>
{
    var transitions: Map<S, Map<T, S>>;
    var defaultTransitions: Map<S, S>;

    public function new()
    {
        transitions = [ ];
        defaultTransitions = [ ];
    }

    /**
     * Adds a transition link between two states.
     *
     * @param from the source state
     * @param transition the transition from the `from` state
     * @param to the state after `transition` occurs from the `from` state
     * @return self for chaining
     */
    public function add(from: S, transition: T, to: S): StateMachine<S, T>
    {
        if (!transitions.exists(from))
        {
            transitions.set(from, [ ]);
        }

        if (transitions[ from ].exists(transition))
        {
            DexError.error('cannot add transition $from+$transition->$to, transition already exists (to ${transitions[ from ][ transition ]})');
        }

        transitions[ from ].set(transition, to);

        return this;
    }

    /**
     * Adds a default transition link between two states.
     *
     * The state will transition from `from` to `to` when any transition occurs,
     * for which the `from` state does not already define a specific link.
     *
     * @param from the source state
     * @param to the state after any transition occurs from the `from` state
     */
    public function addDefault(from: S, to: S): StateMachine<S, T>
    {
        if (defaultTransitions.exists(from))
        {
            DexError.error('cannot add default transition $from->$to, transition already exists (to ${defaultTransitions[ from ]})');
        }

        defaultTransitions.set(from, to);

        return this;
    }

    /**
     * Advances the state machine with a given transition.
     *
     * If the given transition is not defined from the current state, this method will
     * lead to error.
     *
     * Use the `canTransition()` method first to check if the transition is possible.
     *
     * @param state the state to transition from
     * @param transition the transition to perform from the current state
     * @return the new state of the state machine
     */
    public function transition(state: S, transition: T): S
    {
        var nextState: S = state;

        if (transitions.exists(state) && transitions[ state ].exists(transition))
        {
            nextState = transitions[ state ][ transition ];
        }
        else if (defaultTransitions.exists(state))
        {
            nextState = defaultTransitions[ state ];
        }
        else
        {
            DexError.error('current state $state does not define transition $transition');
        }

        return nextState;
    }

    /**
     * Advances the state machine with a default transition.
     *
     * If the current state does not have a default transition defined, an error will be thrown.
     *
     * @param state the state to transition from
     * @return the new state of the state machine
     */
    public function transitionDefault(state: S): S
    {
        if (!defaultTransitions.exists(state))
        {
            DexError.error('current state $state does not define a default transition');
        }

        return defaultTransitions[ state ];
    }

    /**
     * Get a list of the available transitions from the current state.
     *
     * @param state the state to transition from
     * @return an iterator over the available transitions
     */
    public function getAvailableTransitions(state: S): Iterator<T>
    {
        if (!transitions.exists(state))
        {
            DexError.error('transitions not defined from state: $state');
        }

        return transitions[ state ].keys();
    }

    /**
     * This method checks if a given transition is possible from the current state.
     *
     * @param state the state to transition from
     * @param transition the transition
     * @return `true` if the given transition can be applied to the current state
     */
    public function canTransition(state: S, transition: T): Bool
    {
        if (!transitions.exists(state))
        {
            DexError.error('transitions not defined from state: $state');
        }

        return transitions[ state ].exists(transition) || defaultTransitions.exists(state);
    }

    /**
     * Static shortcut method for creating a state machine from maps
     *
     * @param initialState the initial state
     * @param stateTransitions the transitions available from each state
     * @param defaultTransitions the default transitions from each state
     * @return the state machine
     */
    public static function create<S: Int, T: Int>(stateTransitions: Map<S, Map<T, S>>, ?defaultTransitions: Map<S, S>): StateMachine<S, T>
    {
        var stateMachine: StateMachine<S, T> = new StateMachine();

        for (from => transitions in stateTransitions)
        {
            for (transition => to in transitions)
            {
                stateMachine.add(from, transition, to);
            }
        }

        if (defaultTransitions != null)
        {
            for (from => to in defaultTransitions)
            {
                stateMachine.addDefault(from, to);
            }
        }

        return stateMachine;
    }
}
