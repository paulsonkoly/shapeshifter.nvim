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

Press multiple times to tooggle between the two.

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

## Plans

Not much is implemented yet, but plan is to be able to transition between:

 - endless method <-> single line method &#x2705;
 - single body condition <-> postfix condition &#x2705;
 - multiline_do_end -> single_line_curly_block
 - single_line_curly_block -> multiline_do_end  
 - single_line_parameter_list -> muliline_parameter_list
 - muliline_parameter_list -> single_line_parameter_list

Maybe more languages. Maybe more features. As of now, it's early days.

## Technology

Treesitter. Lua. Nvim

## Credits

Inspired by [splitjoin](https://github.com/AndrewRadev/splitjoin.vim)
