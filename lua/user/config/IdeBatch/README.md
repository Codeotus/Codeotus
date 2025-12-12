What this IDEBatch does ?
How to make C & Cpp work easy in terms of compiling ?

IdeBatch is designed to give the IDE like feel & here it contains most Ide features like smart compilation for C & Cpp et.. fuzzy finding with telescope etc etc ...

The IdeBatch does have two files to make your workflow easy if working with c/cpp or even any non c language. Here is the details:

1. compiler_smart.lua (cos) is the dependency/module for code_runner_on_click.lua or (croc) the croc is just a code runner plugin configuration that directly executes the file by making it a binary of its own name & it works well with other popular compilers if they are available else will fail. 

2. The cos is more of a library flag container for c & cpp to preform better c & cpp executions and they mostly require you to add the library flags and are mostly usefull only for small to medium or even big and complex projects if they require libs.

3. If you called some libs that are not in your system then the compilation will fail so you have to manage libraries yourself.

4. It is better to use only best compilers for e.g Gcc/G++ or Clang/Clang++ or rust_analyzer instead of any random compiler.

5. Add you command in cos for e.g rust = ".....", and call the file type inside croc.
