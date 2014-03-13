function qps2mat()
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
% For most problems, rl is the same as ru, which means the problems are
% in the following format
%
% 	min 0.5 x'Qx + c'x
%   s.t. Ax = b 					(setting b = rl)
%        lb <= x  <= ub.
%
% If so, this function will set b = rl (or ru) and save just Q, A, b, lb and ub.
% These problems are consistent with the discrption from I. Maros, Cs. Meszaros.
%
% *** BUT we do observe that for some problems, rl ~= ru. ***
% You will see some problems with rl = -inf and ru = +inf, which implies that 
% Ax is free and there is no need to have A.
%
% Curently I have no idea whether it is a bug in coinRead or these problems are
% just like this.
%
%     *For this case I will save all infomation, namely 
%      Q, A, ru, rb, lb and ub* 
% 
% Yiming Yan
% University of Edinburgh
% 01 November 2013
clc;

files = dir( '*.QPS' );
% files = dir( 'DPKLO1.QPS' );
numProb = length(files);
fprintf( 'In total %d problem detected.\n', numProb )
for i = 1:numProb
    %% Read QPS file
    name = files(i).name;
    fprintf( '%3d - %11s: ', i, name(1:end-2) );
    p = coinRead( name, 'QPS' );
    
    %% Assign data
    c  = p.f;
    A  = p.A;      Q = p.H;
    ru = p.ru;    rl = p.rl;
    lb = p.lb;    ub = p.ub;
 	
	%% Check rl and ru
	rl_is_ru = all(ru == rl);
	
	%% Save data   
 	if rl_is_ru
		b = rl;
    	save( ['MAT_Files\' name(1:end-3) 'mat'], 'Q', 'A', 'b', 'c', 'lb', 'ub');
	else
		fprintf('rl ~= ru; ');
		rl_ru_inf = all(isinf(rl).*isinf(ru));
		if rl_ru_inf
			fprintf('rl=-inf, ru=_inf, Ax free; ');
		else

		end
	end
    
	fprintf( 'Done\n' );

end % end for
end  % end main func
