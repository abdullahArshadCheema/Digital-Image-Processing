bw = [1 1 1 0 0 0 0 0;
      1 1 1 0 1 1 0 0;
      1 1 1 0 1 1 0 0;
      1 1 1 0 0 0 1 0;
      1 1 1 0 0 0 1 0;
      1 1 1 0 0 0 1 0;
      1 1 1 0 0 1 1 0;
      1 1 1 0 0 0 0 0;
     ];
  
bw_rows = size(bw, 1);
bw_cols = size(bw, 2);
labels =  zeros(bw_rows, bw_cols);
label_no = 0;
equivalence_pairs = [];
equ_row = 0;

% First pass to assign labels
for col=1: bw_cols
    for row=1: bw_rows
        p = bw(row, col);   % get pixel value
        if  p == 0
            continue
        else                 % when pixel value is 1
           if (row ~= 1) && (col ~= 1)      % Exclude 1st row, 1st column
               top = bw(row-1, col);
               left = bw(row, col-1);
               
               top_lb = labels(row-1, col);
               left_lb = labels(row, col-1);
               
            if (top == 0) && (left == 0)
                label_no = label_no+1;
                labels(row, col) = label_no;
                
            elseif ((top == 0) && (left ~= 0)) || ((top ~= 0) && (left == 0))   % Either of the neighbors is 1
                if (top == 1)
                    labels(row, col) = top_lb;
                else
                    labels(row, col) = left_lb;
                end
                
            else                                                       % Both neigbors are 1's
                if top_lb == left_lb 
                    labels(row, col) = top_lb;
                else 
                    labels(row, col) = left_lb;
                    equ_row=equ_row+1;
                    equivalence_pairs(equ_row, 1) = top_lb;
                    equivalence_pairs(equ_row, 2) = left_lb;   
                end
            end
            
           elseif(row == 1 && col ~= 1)    % Operates 1st row elements except 1st column element
               left = bw(row, col-1);
               left_lb = labels(row, col-1);
               
               if (left == 0)
                   label_no = label_no+1;
                   labels(row, col) = label_no; 
               else 
                   labels(row, col) = left_lb;
               end
               
           elseif(row ~= 1 && col == 1)    % Operates 1st column elements excepts 1st row element
               top = bw(row-1, col);
               top_lb = labels(row-1, col);
               
               if (top == 0)
                   label_no = label_no+1;
                   labels(row, col) = label_no; 
               else 
                   labels(row, col) = top_lb; 
               end
               
           else            % Operates on the first element.
               label_no = label_no+1;
               labels(row, col) = label_no; 
           end
        end
    end
end

% Processing equivalence pairs to form equivalence classes
labels
equivalence_pairs
equivalence_classes = equivalence_pairs(1, :);
e_row=1;

[rows, cols] = size(equivalence_pairs);
for i = 2: rows
    for j = 1: cols
        new_class_row = 0;
        [class_rows, class_cols] = size(equivalence_classes);
        for k=1: class_rows
            for m=1: class_cols
                if(equivalence_pairs(i, j) == equivalence_classes(k, m))
                    new_class_row = 1;
                    count = 1;
                    class_cols = size(equivalence_classes, 2);
                    for n=1: class_cols
                        equi_val = equivalence_pairs(i, n);
                        if(equivalence_pairs(i, j) ~= equi_val)
                            equivalence_classes(k, class_cols+count)=equi_val;
                            count=count+1;
                        end
                    end
                    break     
                end
            end
        end
         if(j == size(equivalence_pairs, 2) && new_class_row ~= 1 )
                    e_row=e_row+1;
                    equivalence_classes(e_row, 1:cols) = equivalence_pairs(i, 1:cols);     
         end
    end
end

equivalence_classes
% Second pass to replace each label by the label assigned to its
% equivalence classes.

[class_rows, class_cols] = size(equivalence_classes);

for col = 1: bw_cols
    for row = 1: bw_rows
       if labels(row, col) ~= 0
        for i=1: class_rows
            for j=1: class_cols
                if labels(row, col) == equivalence_classes(i, j)
                    labels(row, col) = max(equivalence_classes(i, :));
                end
            end
        end
       end
    end
end

labels



