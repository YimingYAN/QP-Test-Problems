function mps2mat_all()
% MPS2MAT This function uses the coinRead function from OPTI to
% read the QPS file and then save the corresponding file as a mat file
%
% see also coinRead
% + Igonore all int constraints
% + Problem type obtained by coinRead:
%   min 0.5 x'Qx + c'x
%   s.t. rl <= Ax <= ru
%        lb <= x  <= ub.
%
% + We eventrully transform the above problem to it's standard form, namely
%
%   min 0.5 x'Qx + c'x
%   s.t. Ax = b
%        x >= 0,
%
% and then save it as a .mat file
%
%
% Yiming Yan
% University of Edinburgh
% 01 November 2013
clc;
warning off;

files = dir( '*.QPS' );
% files = dir( 'DPKLO1.QPS' );
numProb = length(files);
fprintf( 'In total %d problem detected.\n', numProb )
for i = 25:numProb
    %% Read QPS file
    name = files(i).name;
    fprintf( '%3d - %11s: ', i, name(1:end-2) );
    p = coinRead( name, 'QPS' );
    
    % Assign data
    c  = p.f;
    A  = p.A;      Q = p.H;
    ru = p.ru;    rl = p.rl;
    lb = p.lb;    ub = p.ub;
    
    try 
    [Q, A, b, c, lb, ub] = tran_to_equalityConstraints(Q, A, c, ru, rl, lb, ub);
    catch
       fprintf('free Ax=b');
       continue;
    end
    %% Transform to standard form 2:
    %            lb <= x <= ub ---> x >= 0
    try
        [Q,A,b,c] = tran_to_standard(Q,A,b,c, lb, ub, inf);
    catch
        fprintf('Skip: mixture of free and bounded variables\n');
        continue
    end
    save( ['mats\' name(1:end-3) 'mat'], 'Q', 'A', 'b', 'c');
    fprintf( 'Done\n' );
    
    
end % end for
end  % end main func

function  [Q, A, b, c, lb, ub] = tran_to_equalityConstraints(Q, A, c, ru, rl, lb, ub)
% This function tansform the following problem
%   min 0.5 x'Qx + c'x
%   s.t. rl <= Ax <= ru
%        lb <= x  <= ub.
% to
%
%           min 0.5 x'Qx + c'x
%          s.t. Ax = b
%               lb <= x <= ub
%
%

% Check if Ax = b free
if all(isinf(rl)) && all(isinf(ru))
    error('free Ax = b');
end

infeasible = 0;
unbounded  = 0;

[ m, n ] = size( A );
b = zeros( m, 1 );
k = 1;
num_slack = 0;
%% Transform to standard form 1:
%            rl <= Ax <= ru ---> Ax = b
while k <= m
    %  rl(k) > ru(k) -> infeasible
    if rl(k) > ru(k)
        infeasible = 1;
        break;
    elseif rl(k) == ru(k)  % rl(k) == ru(k)
        % rl(k) = ru(k) = +inf or -inf -> infeasible
        if isinf( rl(k) )
            infeasible = 1;
            break;
        end
        
        % rl(k) = ru(k), finite
        b(k) = rl(k);
        
    else%  rl(k) < ru(k):
        %     1) rl(k) = -inf and ru(k) finite     ->
        %        add one col [0 ... 1 ... 0]' to A
        if isinf( rl(k) ) && ~isinf( ru(k) )
            A(k, end+1) = 1;
            b(k) = ru(k);
            
            num_slack = num_slack+1;
            
            % 2) rl(k) = finite and ru(k) = +inf   ->
            %    add one col [0 ... -1 ... 0]' to A
        elseif ~isinf( rl(k) ) && isinf( ru(k) )
            A(k, end+1) = -1;
            
            num_slack = num_slack+1;
            
            % 3) rl(k) = finite and ru(k) = finite ->
            %    add one col [0 ... -1 ... 0]' to A first,
            %    then duplicate and add a'_k to the end of A
            %    and finally add another col [0 ... 1 ... 0]' to A
        elseif ~isinf( rl(k) ) && ~isinf( ru(k) )
            A(k, end+1) = -1;
            b(k) = rl(k);
            
            A = [A; A(k,:)]; A(end, end) = 0;
            
            A(end, end+1) = 1;
            b(end+1) = ru(k);
            
            num_slack = num_slack+2;
            
            % 4) rl(k) = -inf and ru(k) = +inf     ->
            %    if c_k not zero, unbounded, else
            %    remove x_k, a'_k, c_k, and kth row and col of Q
        else
            if c(k) == 0
                unbounded = 1;
                break;
            end
            
            A(k,:) = []; b(k) = []; c(k) = [];
            Q(k,:) = []; Q(:,k) = [];
            
            lb(k) = []; ub(k) = [];
            
            % Don't increase k
            continue;
        end
    end % end rl(k) > ru(k)
    k = k+1;
end % end while
c = [c; zeros(num_slack,1)];
Q = [Q                      sparse( n, num_slack )          ;
    sparse( num_slack, n ) sparse( num_slack, num_slack ) ];

lb = [ lb;    zeros( num_slack, 1 ) ];
ub = [ ub; inf*ones( num_slack, 1 ) ];

if infeasible || unbounded
    Q  = [];
    A  = [];  b  = []; c= [];
    lb = [];  ub = [];
end
end

function [Q,A,b,c] = tran_to_standard(Q,A,b,c, lb, ub, BIG)
% tran_to_standard This function transform the following QP problem
%
%           min 0.5 x'Qx + c'x
%          s.t. Ax = b
%               lb <= x <= ub
%
% to its standard form, namely
%
%           min [t s]'[ Q 0 ][t] + [(Q*lb+c)' 0] [t]
%                     [ 0 0 ][s]                 [s]
%
%           s.t.  [A 0][t] = [b-A * lb]
%                 [M 0][s]   [ ub - lb]
%                            [t]
%                            [s] >=0,
%
% where M(:,index) forms identy matrix and the rest are all zeros.
%
% Warning: This function does not handle mixture of free variables and bounded
% variables, namely, either all variables are free or all bounded.
%
% If all x are free:
% x'Qx  = (x1-x2)'Q(x1-x2) = x1'Qx1 - 2x1'Qx2 + x2'Qx2 = [x1' x2'][Q   -Q ][x1]
%                                                                 [-Q   Q ][x2]
%
% [ x1'Q-x2'Q    -x1'Q+x2'Q ] [x1] = x1'Qx1 - x2'Qx1 - x1'Qx2 + x2'Qx2
%                             [x2]
%
% c'x = c'(x1-x2) = c'x1 - c'x2 = [c' -c'][x1]
%                                         [x2]
% Ax=A(x1-x2) = [A -A][x1]
%                     [x2]
%
% So  A = [A -A], b = b, c=[ c; -c ], Q = [Q -Q; -Q Q]
%
[m,n] = size(A);
standardForm = 1;

% Check if the variables are free or not
index_inf = isinf(lb).*isinf(ub);

if all(index_inf)
    fprintf('all free variables\n');
    A = [A -A];  c = [ c; -c ]; Q = [Q -Q; -Q Q];
else
    if any(index_inf)
        error('Does not handle mixture of free and bounded variables');
    end
    
    Lbounds_non0 = any(lb ~= 0);
    if Lbounds_non0
        % fprintf('lbounds exisit\n');
        standardForm = 0;
    end
    
    U = spones(ub<BIG);
    if any(U)
        % fprintf('ubounds exisit\n');
        standardForm = 0;
        indexu = find(U>0);
    else
        indexu = [];
    end
    
    if ~standardForm
        %fprintf('Change it to standard form...\n');
        
        tmp_n = length(indexu);
        tmp_A = A;
        M = sparse(tmp_n, n);
        M(:, indexu) = speye(tmp_n);
        
        A = [tmp_A sparse(m,tmp_n); M speye(tmp_n)];
        b = [b-tmp_A*lb; ub(indexu)-lb(indexu)];
        c = [Q*lb+c; sparse(tmp_n,1)];
        
        Q = [ Q sparse(n, tmp_n); sparse(tmp_n, n) sparse(tmp_n, tmp_n) ];
    end
end

end
