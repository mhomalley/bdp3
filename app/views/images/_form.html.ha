%table
  %tr
    %td
      %label{:for => "image_file_name"}
        File Name:
    %td
      = f.file_field(:file_name, :size => 80)
  %tr
    %td
      %label{:for => "image_author"}
        Author:
    %td
      = f.text_area(:author, :cols => 50, :rows => 1)
  %tr
    %td
      %label{:for => "image_caption"}
        Caption:
    %td
      = f.text_area(:caption, :cols => 90, :rows => 4)
