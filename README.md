## PureScript Experiments

### Dependencies

* `purescript` (I currently seem to be using `0.11.5`)
* `pulp`
* `bower`

I forget how I usually install PureScript, I think I build from source?

### Building

In a given subdirectory,

1. `bower install`
2. `pulp build`
3. `pulp server` or `pulp run`, depending

### Experiments

 * `drawing` - an experiment using `purescript-drawing` to draw some random circles, and perhaps later some other things
 
 * `aff` - experiments using `purescript-aff` to do things like maybe delay and schedule events
 
### Things I Forget

 * When using `bower` to install a new PureScript package, `--save` will automatically update `bower.json` for you
 * You can ask `psc` to tell you the inferred type of a thing `x <- ...` with `(x :: _)`
