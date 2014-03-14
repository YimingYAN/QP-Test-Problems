function setup( )
% SETUP This function is used to setup the funcion coinRead from OPTI
% Toolbox.
%
% Copyright declaration:
% OPTI Toolbox: http://www.i2c2.aut.ac.nz/Wiki/OPTI/
% CoinUtils   : https://projects.coin-or.org/CoinUtils
%
% For licenses, see disctribution folder.

%% Declaration
fprintf('======================================================================\n');
fprintf('This function is used to setup the funcion coinRead from OPTI Toolbox.\n');
fprintf('Copyright declaration: \n');
fprintf('OPTI Toolbox: http://www.i2c2.aut.ac.nz/Wiki/OPTI/\n');
fprintf('CoinUtils   : https://projects.coin-or.org/CoinUtils\n');
fprintf('Yiming Yan @ University of Edinburgh, 01/11/2013\n')
fprintf('======================================================================\n');

%% Check OS
if ~ispc
    error('The tool coinRead only works under Windows 32-bit or 64-bit');
end

%% Addpath
folder = pwd;
path_new = genpath( folder );
addpath( path_new );
%% Test
try
    p = coinRead('QAFIRO.QPS','QPS',1);
    
    fprintf('\nDone.\n')
    fprintf('Please run qps2mat function.\n');
catch err
    error('Unsuccessful!!\n');
end

end

