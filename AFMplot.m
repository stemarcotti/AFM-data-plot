% this algorithm takes files from the AFM microscope (.txt) and plot them

% .png files are saved as output in a folder of choice

% 0_ INPUT
% here information about the experiment need to be entered
input_folder = 'D:\WORK\AFM';	% where are raw data files
% where are the files going to be saved?
output_folder = 'D:\WORK\AFM\output';	% name folder
mkdir(output_folder);                   % create output folder
% what is the working folder for Matlab?
working_folder = 'D:\WORK\Matlab';

% 1_ open folder and list files
data_folder = cd (input_folder);
D = dir('*.txt');  % make a file list (D) of the (.txt) data in data_folder
[~,index] = sortrows({D.date}.'); D = D(index); clear index	% order data by acquisition time
D_cell = struct2cell(D); D_cell_filename = D_cell(1,:)';	% create cell array of strings with file-names

% 2_ FOR cycle which opens one file at the time and draw plot
for i = 1:size(D_cell_filename,1)   % open file (name order)

    % 2a_ open file
    cd (input_folder);
    myfilename = D_cell_filename{i};
    fileID = fopen(myfilename);
    C = textscan(fileID, '%f%f%f%f', 'CommentStyle', '#');  % raw files contain 4 columns
    mydata = cell2mat(C);  % save data of file(i) into matrix mydata
    fclose(fileID);
    cd (working_folder)

    % 2b_ save data from file into arrays
    height = mydata(:,1);	% [nm]
    force = mydata(:,2);	% [nN]
    series = mydata(:,3);	% [s]
    segment = mydata(:,4);	% [s]

    segment_start = zeros(4,1);
    jj = 1;
    for ii = 1:length(segment)-1
        if segment(ii)-segment(ii+1) > 0.1
            segment_start(jj,1) = (ii+1);  % index of [segment] change from extend to retract
            jj = jj+1;
        end
    end

    % extend (E) data
    force_E = force(1:segment_start(1)-1);
    height_E = height(1:segment_start(1)-1);
    series_E = series(1:segment_start(1)-1);
    segment_E = segment(1:segment_start(1)-1);
    % retract (R) data
    force_R = force(segment_start(1):end);
    height_R = height(segment_start(1):end);
    series_R = series(segment_start(1):end);
    segment_R = segment(segment_start(1):end);

    % 2c_ plot
    figure('Visible','off') % remove arguments if rendering on screen is required
    plot(height_E, force_E, height_R, force_R, 'linewidth', 2)
    xlabel('Height [nm]')
    ylabel('Force [pN]')
    title(myfilename)
    legend('Extend','Retract')
    grid on   % set major grid
    box off   % remove box (top and right)
    ax = gca;
    ax.GridLineStyle = ':'; % change grid line style to points
    set(gca,'FontSize',12)  % set the font size to 12 pt.

    % 2d_ save figure in output folder
    cd(output_folder);
    myplotname = sprintf('Figure %d', i);
    print(myplotname,'-dpng')

end
