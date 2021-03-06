%
%  Copyright (c) 2018 James Pritts
%  Licensed under the MIT License (see LICENSE for details)
%
%  Written by James Pritts
%
function affpt = apply_T_to_affpt(affpt,T)
A = LAF.affpt_to_A(affpt);
TA0 = cellfun(@(x) T*x,A,'UniformOutput',false);
TA = reshape(cell2mat(TA0'),3,3,[]);
TA = reshape(TA,9,[]);
a11 = num2cell(TA(1,:));
a21 = num2cell(TA(2,:));
a12 = num2cell(TA(4,:));
a22 = num2cell(TA(5,:));
x = num2cell(TA(7,:));
y = num2cell(TA(8,:));
[affpt.a11] = deal(a11{:});
[affpt.a21] = deal(a21{:});
[affpt.a12] = deal(a12{:});
[affpt.a22] = deal(a22{:});
[affpt.x] = deal(x{:});
[affpt.y] = deal(y{:});