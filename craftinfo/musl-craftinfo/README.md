# musl-craftinfo

Craftinfo for mulle-sde to build [musl](//github.com/<|GITHUB_USER|>/musl)

```
mulle-sde dependency add --github <|GITHUB_USER|> musl
mulle-sde dependency mark musl singlephase
# mulle-sde dependency set musl aliases musl-other
# mulle-sde dependency set musl include musl-other.h
# mulle-sde environment --global set MULLE_CRAFT_USE_SCRIPT YES
```

## Tips

* If you want to define `CFLAGS` use `definition/set/append/CFLAGS` instead of `definition/set/CFLAGS` so that you can still add flags with the environment variable `CFLAGS`. Or use `mulle-sde dependency craftinfo  set --append musl CFLAGS "-DX=0`
* use `CPPFLAGS` instead of `CFLAGS` to match C++, C and Objective-C
* you can use `definition/set/append0` to append a string without an intervening space
* you can use `definition/set/remove` to remove a definition
