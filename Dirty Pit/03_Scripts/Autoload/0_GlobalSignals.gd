extends Node

###### FROM PAUSE PANEL ######
# warning-ignore:unused_signal
signal _game_paused
# warning-ignore:unused_signal
signal _game_unpaused
# warning-ignore:unused_signal
signal _resign_from_fight

##### FROM MENU ######
# warning-ignore:unused_signal
signal _hero_picked
# warning-ignore:unused_signal
signal _prepare_opponent
# warning-ignore:unused_signal
signal _prepare_your_hero
# warning-ignore:unused_signal
signal _new_fight_started

##### FROM ARENA ####
# warning-ignore:unused_signal
signal _you_win
# warning-ignore:unused_signal
signal _you_lost
# warning-ignore:unused_signal
signal _ready_to_see_opponent_combination
# warning-ignore:unused_signal
signal _your_comb_ready_before_times_up
# warning-ignore:unused_signal
signal _prepare_new_combination_for_hero
# warning-ignore:unused_signal
signal _start_exchange_of_hits
# warning-ignore:unused_signal
signal _exchange_of_hits_is_over
# warning-ignore:unused_signal
signal _arena_is_asking_a_question
# warning-ignore:unused_signal
signal _arena_stopped_asking_a_question
# warning-ignore:unused_signal
signal _player_wants_to_watch_comb_again

##### FROM HERO ####
# warning-ignore:unused_signal
signal _opponent_sequance_completed
# warning-ignore:unused_signal
signal _opponent_get_back_from_showing_sequance
# warning-ignore:unused_signal
signal _your_turn
# warning-ignore:unused_signal
signal _your_time_is_up
# warning-ignore:unused_signal
signal _you_prepared_your_sequance
# warning-ignore:unused_signal
signal _show_interaction
# warning-ignore:unused_signal
signal _you_can_see_another_sequance
# warning-ignore:unused_signal
signal _one_of_the_heroes_is_dead
# warning-ignore:unused_signal
signal _fight_is_over
# warning-ignore:unused_signal
signal _show_action_description
# warning-ignore:unused_signal
signal _load_hero_availability

#### COMMON SIGNALS ####
# warning-ignore:unused_signal
signal _save_stats

