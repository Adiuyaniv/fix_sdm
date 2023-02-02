

parametricdatapath='C:\Users\User\Documents\MRHI\Fix\parametric_sdm\SDM_VT_BO_parametric'
gPPIdatapath='C:\Users\User\Documents\MRHI\Fix\gPPI_sdm\VT_BO_gPPI'
addpath 'C:\Users\User\Documents\matlab_code'
addpath (gPPIdatapath)
addpath (parametricdatapath)

 gPPI_files =  findfiles('sdm', gPPIdatapath);
 parametric_files =  findfiles('sdm', parametricdatapath);

 matched_pairs = match_files2( gPPI_files, parametric_files);
 counter = 1; % Initialize subplot counter

figure; % Create new figure before loop starts


for matched_pair=1:length(matched_pairs)
      voi_tc=import_timecourse(matched_pairs(matched_pair).file1);
    runum = matched_pairs(matched_pair).run_num;
    if str2num(runum) == 1
        parametric_pred=import_para_run1(matched_pairs(matched_pair).file2);
        index_vec_to_replace  = 3;
    else if str2num(runum) == 2
        parametric_pred=import_para_run2(matched_pairs(matched_pair).file2);
        index_vec_to_replace  = 4;
    else
        parametric_pred=import_para_run3(matched_pairs(matched_pair).file2);
        index_vec_to_replace  = 5;
    end
    end
    original_parametric=parametric_pred; %save the original parametric
    parametric_pred=parametric_pred+(abs(min(parametric_pred))+1); % make the minimum=1
    gPPI_correct_pred = multiply_elementwise(voi_tc,parametric_pred); % multiply timecourse and parametric
    gPPI_correct_pred(gPPI_correct_pred==0) = 0;%remove minus zero if any

    modify_sdm_file4(matched_pairs(matched_pair).file1, index_vec_to_replace, gPPI_correct_pred);
    subplot(3, 3, counter); % Create new subplot for each iteration
    plot(voi_tc)
    hold on;
    plot(original_parametric)
    hold on;
    plot(parametric_pred)
    hold on;
    plot(gPPI_correct_pred)
    runum = matched_pairs(matched_pair).run_num;
    subnum = matched_pairs(matched_pair).sub_num;
    title(sprintf('Run %s, Sub %s', runum, subnum)) % Give subplot a title
    counter = counter + 1; % Increment subplot counter
    if mod(counter, 9) == 1 % Save figure and add legend after every 12 subplots
        legend('voi tc','original parametric','parametric pred','gPPI correct pred','Location', 'southoutside'); % Add legend to current figure
        saveas(gcf, sprintf('%d_VT_BO.png', subnum)) % Include batch counter in file name
        clf % Clear current figure to start a new one
        counter=1;
    end
end