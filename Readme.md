# shapeshifter.nvim

Changes code shape / style toggling between implementation variants. For example you can write an endless ruby method:

   ```ruby
   def foo(x = 13, y: 14) = @x + x - @y + y
   ```

position over the method definition anywhere, and trigger `shapeshifter.shiftshape`. You should get the following rewrite:


   ```ruby
   def foo(x = 13, y: 14)
     @x + x - @y + y
   end
   ```

## Plans

Not much is implemented yet, but plan is to be able to transition between:

 - endless_method -> normal_method
 - normal_method -> endless_method
 - multiline_do_end -> single_line_curly_block
 - single_line_curly_block -> multiline_do_end  
 - single_line_parameter_list -> muliline_parameter_list
 - muliline_parameter_list -> single_line_parameter_list

Maybe more languages. Maybe more features. As of now, it's early days.

## Technology

Treesitter. Lua. Nvim
