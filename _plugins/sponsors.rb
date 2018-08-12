module Jekyll
    class SponsorsTag < Liquid::Tag
        def initialize(tag_name, text, tokens)
            super
            @text = text
          end
      
          def render(context)
            sponsors = context.registers[:site].data['sponsors']
            sponsor_types =  context.registers[:site].data['sponsor_types']
            output=""
            sponsors.group_by {|sponsor| sponsor['type']}
                .sort_by {|type, sponsors| sponsor_types.select {|st| st['name'] == type }[0]['order']}
                .each do |type, sponsors|
                sponsor_type_description = sponsor_types.select {|st| st['name'] == type}[0]['description']
                output += "<div class='panel panel-default'>"
                output += "<div class='panel-heading'>#{sponsor_type_description}</div>"
                output += "<div class='panel-body'>"
                sponsor_columns = []
                sponsors.each do |sponsor|
                    if sponsor_columns.length == 3
                        output += sponsors_wrap_in_row(sponsor_columns)
                    else
                        sponsor_columns.push(sponsor_html_column(sponsor))
                    end
                end
                output += sponsors_wrap_in_row(sponsor_columns) if sponsor_columns.length > 0
                output += "</div></div>"
            end
            return output
        end

        def sponsors_wrap_in_row(sponsor_columns)
            output = ""
            output += "<div class='row'>"
            output += sponsor_columns.join()
            output += "</div>"
            sponsor_columns.clear()
            output
        end

        def sponsor_html_column(sponsor)
            <<~EOF
                <div class="col-md-4 col-sm-6 col-xxs-12 animate-box">
                <a href="#{sponsor['website']}" target="_blank" class="sponsor-item">
                <img src="images/sponsors/#{sponsor['image']}" alt="#{sponsor['name']}" class="img-responsive center-block" />
                <div class="text">
                    <h2>#{sponsor['name']}</h2>
                    <p>#{sponsor['description']}</p>
                </div>
                </a>
                </div>
            EOF
        end
    end
end

Liquid::Template.register_tag('sponsors', Jekyll::SponsorsTag)