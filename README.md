## Usage

Call `EhDocs()` to look up the current keyword.

There is also a keymapping for this. It defaults to `<leader>k`.

EhDocs will look up the module or function currently under the cursor,
by calling whatever `keywordprg` you have defined, for example
[eh](https://hex.pm/packages/eh).

Examples: (`<x>` means that the cursor placed on `x`)

For docs on the `Foo` module:

    (<F>oo.Bar.baz)
    <F>oo.Bar.baz()
    F<o>o.Bar.baz()
    Fo<o>.Bar.baz()
    Foo<.>Bar.baz()

For docs on the `Foo.Bar` module:

    (Foo.<B>ar.baz())
    Foo.<B>ar.baz()
    Foo.B<a>r.baz()
    Foo.Ba<r>.baz()
    Foo.Bar<.>baz()

For docs on the `Foo.Bar.baz` function:

    (Foo.Bar.<b>az())
    Foo.Bar.<b>az()
    Foo.Bar.b<a>z()
    Foo.Bar.ba<z>()
    Foo.Bar.baz<(>)
    Foo.Bar.baz< >args
    Foo.Bar.baz<$>

## Configuration

Configure eh-docs map prefix (default is `<leader>`) with

    let g:ehdocs_map_prefix = '<leader>'

Switch lookup command (default is `mix eh`) with

    let g:ehdocs_lookup_command = 'mix eh'

## Dependencies

EhDocs depends on having something that works like "eh", or the built-in
IEx.Helpers.h function, callable using

    `:call g:ehdocs_lookup_command .  " " . some_key_word`

