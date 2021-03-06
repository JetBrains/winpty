# Next version

 * Fix a bug that could have generated spurious mouse input records when an
   incomplete mouse escape sequence was seen.

# Version 0.2.1 (2015-12-19)

 * The main project source was moved into a `src` directory for better code
   organization and to fix
   [#51](https://github.com/rprichard/winpty/issues/51).
 * winpty recognizes many more escape sequences, including:
    * putty/rxvt's F1-F4 keys
      [#40](https://github.com/rprichard/winpty/issues/40)
    * the Linux virtual console's F1-F5 keys
    * the "application numpad" keys (e.g. enabled with DECPAM)
 * Fixed handling of Shift-Alt-O and Alt-[.
 * Added support for mouse input.  The UNIX adapter has a `--mouse` argument
   that puts the terminal into mouse mode, but the agent recognizes mouse
   input even without the argument.  The agent recognizes double-clicks using
   Windows' double-click interval setting (i.e. GetDoubleClickTime).
   [#57](https://github.com/rprichard/winpty/issues/57)

Changes to debugging interfaces:

 * The `WINPTY_DEBUG` variable is now a comma-separated list.  The old
   behavior (i.e. tracing) is enabled with `WINPTY_DEBUG=trace`.
 * The UNIX adapter program now has a `--showkey` argument that dumps input
   bytes.
 * The `winpty-agent.exe` program has a `--show-input` argument that dumps
   `INPUT_RECORD` records.  (It omits mouse events unless `--with-mouse` is
   also specified.)  The agent also responds to `WINPTY_DEBUG=trace,input`,
   which logs input bytes and synthesized console events, and it responds to
   `WINPTY_DEBUG=trace,dump_input_map`, which dumps the internal table of
   escape sequences.

# Version 0.2.0 (2015-11-13)

No changes to the API, but many small changes to the implementation.  The big
changes include:

 * Support for 64-bit Cygwin and MSYS2
 * Support for Windows 10
 * Better Unicode support (especially East Asian languages)

Details:

 * The `configure` script recognizes 64-bit Cygwin and MSYS2 environments and
   selects the appropriate compiler.
 * winpty works much better with the upgraded console in Windows 10.  The
   `conhost.exe` hang can still occur, but only with certain programs, and
   is much less likely to occur.  With the new console, use Mark instead of
   SelectAll, for better performance.
   [#31](https://github.com/rprichard/winpty/issues/31)
   [#30](https://github.com/rprichard/winpty/issues/30)
   [#53](https://github.com/rprichard/winpty/issues/53)
 * The UNIX adapter now calls `setlocale(LC_ALL, "")` to set the locale.
 * Improved Unicode support.  When a console is started with an East Asian code
   page, winpty now chooses an East Asian font rather than Consolas / Lucida
   Console.  Selecting the right font helps synchronize character widths
   between the console and terminal.  (It's not perfect, though.)
   [#41](https://github.com/rprichard/winpty/issues/41)
 * winpty now more-or-less works with programs that change the screen buffer
   or resize the original screen buffer.  If the screen buffer height changes,
   winpty switches to a "direct mode", where it makes no effort to track
   scrolling.  In direct mode, it merely syncs snapshots of the console to the
   terminal.  Caveats:
    * Changing the screen buffer (i.e. `SetConsoleActiveScreenBuffer`)
      breaks winpty on Windows 7.  This problem can eventually be mitigated,
      but never completely fixed, due to Windows 7 bugginess.
    * Resizing the original screen buffer can hang `conhost.exe` on Windows 10.
      Enabling the legacy console is a workaround.
    * If a program changes the screen buffer and then exits, relying on the OS
      to restore the original screen buffer, that restoration probably will not
      happen with winpty.  winpty's behavior can probably be improved here.
 * Improved color handling:
    * DkGray-on-Black text was previously hiddenly completely.  Now it is
      output as DkGray, with a fallback to LtGray on terminals that don't
      recognize the intense colors.
      [#39](https://github.com/rprichard/winpty/issues/39).
    * The console is always initialized to LtGray-on-Black, regardless of the
      user setting, which matches the console color heuristic, which translates
      LtGray-on-Black to "reset SGR parameters."
 * Shift-Tab is recognized correctly now.
   [#19](https://github.com/rprichard/winpty/issues/19)
 * Add a `--version` argument to `winpty-agent.exe` and the UNIX adapter.  The
   argument reports the nominal version (i.e. the `VERSION.txt`) file, with a
   "VERSION_SUFFIX" appended (defaulted to `-dev`), and a git commit hash, if
   the `git` command successfully reports a hash during the build.  The `git`
   command is invoked by either `make` or `gyp`.
 * The agent now combines `ReadConsoleOutputW` calls when it polls the console
   buffer for changes, which may slightly reduce its CPU overhead.
   [#44](https://github.com/rprichard/winpty/issues/44).
 * A `gyp` file is added to help compile with MSVC.
 * The code can now be compiled as C++11 code, though it isn't by default.
   [bde8922e08](https://github.com/rprichard/winpty/commit/bde8922e08c3638e01ecc7b581b676c314163e3c)
 * If winpty can't create a new window station, it charges ahead rather than
   aborting.  This situation might happen if winpty were started from an SSH
   session.
 * Debugging improvements:
    * `WINPTYDBG` is renamed to `WINPTY_DEBUG`, and a new `WINPTY_SHOW_CONSOLE`
      variable keeps the underlying console visible.
    * A `winpty-debugserver.exe` program is built and shipped by default.  It
      collects the trace output enabled with `WINPTY_DEBUG`.
 * The `Makefile` build of winpty now compiles `winpty-agent.exe` and
   `winpty.dll` with -O2.

# Version 0.1.1 (2012-07-28)

Minor bugfix release.

# Version 0.1 (2012-04-17)

Initial release.
