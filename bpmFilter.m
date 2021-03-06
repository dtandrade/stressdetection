function s2 = bpmFilter(s, window)

  %valores de BPM acima de 100 sao retornados em formato diferente; consertar
  multiplier_fix = (s <= 150 && s >= 100) .* 9 + 1;
  f = s * multiplier_fix;
  
  valid = (s > 400);
  s2 = zeros(size(s));
  m = 0;
  
  %para os primeiros valores da serie o calculo eh diferente
  for k = 1:(window - 1)
    in = f(1:k);
    if(sum(in > 400) > 0)
      s2(k) = median(in(in > 400));
    else
      s2(k) = 0;
    end
  end
  
  %o valor inicial de m eh a mediana dos primeiros n valores, descartando os invalidos
  j = 1;
  while f(j) <= 400
    j = j+1;
  end
  in = f(j:window+j-1);
  m = median(in(in > 400));
  
  for k = window:size(s, 1)
    in = f((k-window+1):k);
    in_valid = and(in > 400, in < m+150, in > m-150);
    if(sum(in_valid) > 0)
      m = median(in(in_valid));
    end
    fflush(stdout);
    s2(k) = m;
  end

end