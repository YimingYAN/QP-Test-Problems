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
	files = dir( 'QPS_Files\*.QPS' );
end
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
    rl = p.rl;    ru = p.ru;
    lb = p.lb;    ub = p.ub;
 	
 	clear p;
 	
 	%% Save data
 	save( ['MAT_Files\' name(1:end-3) 'mat'], 'Q', 'c', 'A', 'rl', 'ru', 'lb', 'ub');
 	
	%% Check rl and ru
	rl_is_ru = all(ru == rl);
	
 	if rl_is_ru
		fprint('rl = ru; Ax = b with b = rl; ')
	else
		fprintf('rl ~= ru; ');
		rl_ru_inf = all(isinf(rl).*isinf(ru));
		if rl_ru_inf
			fprintf('rl = -inf, ru = +inf, Ax free; ');
		else
			if all(inf(rl))
				fprintf('rl = -inf, ru ~= +inf; ');
			elseif all(inf(ru))
				fprintf('rl ~= -inf, ru = +inf');
			else
				fprintf('rl ~= -inf, ru ~= +inf');
			end
		end
	end
    
	fprintf( 'Done\n' );

end % end for
end  % end main func
