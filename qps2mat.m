function qps2mat(folderName)
% QPS2MAT This function makes use of the coinRead function from OPTI to
% read the QPS file and then save the corresponding problem as a mat file.
%
% See also: coinRead
%
% ----------------------------------------------------------------------
% Problem type obtained by coinRead is as follows:
%
% 	min 0.5 x'Qx + c'x
%   s.t. rl <= Ax <= ru
%        lb <= x  <= ub.
%
% We save the data Q, c, A, rl, ru, lb and ub.
%
% Yiming Yan
% University of Edinburgh
% 01 November 2013
clc;

if ~ispc
    error('QPS2MAT: Works only on windows system.');
end

if nargin < 1
    folderName = 'QPS_Files';
end

files = dir( [folderName '\*.QPS'] );
% files = dir( 'DPKLO1.QPS' );

numProb = length(files);
fprintf('In total %d problem detected.\n', numProb );
fprintf('%3s %10s %10s %10s %10s %10s %10s %10s\n',...
    'ID.', 'Name', 'rl = ru',...
    'rl = -inf', 'ru = +inf',...
    'lb = 0', 'lb = -inf', 'ub = +inf' );
for i = 1:numProb
    %% Read QPS file
    name = files(i).name;
    fprintf( '%3d %10s ', i, name(1:end-4) );
    
    p = coinRead( [ folderName '\' name ], 'QPS' );
    
    %% Assign data
    c  = p.f;
    A  = p.A;      Q = p.H;
    rl = p.rl;    ru = p.ru;
    lb = p.lb;    ub = p.ub;
    
    clear p;
    
    %% Save data
    save( ['MAT_Files\' name(1:end-3) 'mat'], 'Q', 'c', 'A', 'rl', 'ru', 'lb', 'ub');
    
    %% Check rl and ru
    rl_is_ru = all(ru == rl);
    
    if rl_is_ru
        fprintf('%10s ', 'Yes');
    else
        fprintf('%10s ', 'NO');
    end
    check_inf(rl, ru);
    
    %% Check lb and ub
    if all(lb == 0)
        fprintf(' %10s ', 'Yes');
    else
        fprintf(' %10s ', 'No');
    end
    check_inf(lb, ub);
    fprintf( '\n' );
    
end % end for
end  % end main func

function check_inf(l, u)
if all(isinf(l))
    fprintf('%10s ', 'Yes');
else
    fprintf('%10s ', 'NO');
end
if all(isinf(u))
    fprintf('%10s', 'YES');
else
    fprintf('%10s', 'NO');
end
end
