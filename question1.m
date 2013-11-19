listings = dir('./question1_input');

for i = 1 : numel(listings)
    curr = listings(i);
    if( curr.isdir == 0 && strcmpi( curr.name(end-2:end),'gif' ) )
        compute_orientation_field( fullfile('./question1_input',curr.name) );
    end
end