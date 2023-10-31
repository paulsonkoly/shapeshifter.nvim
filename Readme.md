# shapeshifter.nvim

Changes code shape / style toggling between implementation variants. For example you can write an endless ruby method:

   ```ruby
   def foo(x = 13, y: 14) = @x + x - @y + y
   ```

position anywhere in the method definition, and trigger `shapeshifter.shiftshape`. You will get the following rewrite:


   ```ruby
   def foo(x = 13, y: 14)
     @x + x - @y + y
   end
   ```

Press multiple times to toggle between the two.

## Installation

### Packer

   ```lua
   use {
     'phaul/shapeshifter.nvim',
     requires = { { 'nvim-treesitter/nvim-treesitter' } }
   }
   ```

### Setup

   ```lua
   local shifter = require("shapeshifter")

   vim.keymap.set("n", "<leader>t", shifter.shiftshapes)
   ```

## Usage

shapeshifter utilises treesitter to get access to the document AST. It starts from the current cursor position and looks at the AST node containing the cursor position directly. It checks if it can do any transformation with the node, otherwise it looks for the parent node. It walks the node hierarchy to the root node, checking if the node in focus could be shape shifted. It stops at the first node it finds, and executes the transformation.

Thus if the cursor position is contained within multiple AST nodes that could be transformed, the transformation will only happen for the innermost node. For example a method might be transformed to be endless method, or the argument list might be transformed to be multi line. As the argument list is contained by the method, that is the one that will be executed. 

shapeshifter take a conservative approach, not trying to do a rewrite if it's not certain it's what you wanted. If there are comments in the code chances are it won't know where to put the comments on the rewrite, so it avoids doing anything.

## Plans

Not much is implemented yet, but plan is to be able to transition between:

 - endless method <-> single line method &#x2705;
 - single body condition <-> postfix condition &#x2705;
 - single line do block <-> one liner curly brace block &#x2705;
 - method arguments on single line <-> method arguments on separate lines &#x2705;

Maybe more languages. Maybe more features. As of now, it's early days.

## Technology

Treesitter. Lua. Nvim

## Credits

Inspired by [splitjoin](https://github.com/AndrewRadev/splitjoin.vim)
