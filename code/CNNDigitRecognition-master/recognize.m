function x=recognize(y)
 [~, h] = max(y);
  x=h(1, 1);
end