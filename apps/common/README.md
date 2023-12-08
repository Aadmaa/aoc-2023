# Common

Contains utilities used across Apps

#### Comparison.is_equal
A utility to check the deep equality of Elixir objects. It can ignore the sort order of lists, including nested lists that contain maps. And nested maps and lists are all fine.

This works through recursively utilizing Erlang's phash2/1 to hash objects from the "inside" to the "outside" of a nested list or map. Lists are optionally sorted, so that the comparison will not care about list sort order, depending on the setting of "list_order_irrelevant".

Additionally, the "strict" option is applied recursively, so that a deeply nested integer can be compared strictly or not-strictly to a deeply nested float.

##### Options:
- **strict**: (default=false) Is strict comparison used for numbers? With strict=true, 1 (integer) does not match 1.0 (float)
- **list_order_irrelevant**: (default=false) Does it matter what order things appear on, in Lists? If not, set this to true. 

#### logg
A simple IO logger to log a string and inspect an object (if passed)
