module Jekyll
    class SponsorsTag < Liquid::Tag
        def initialize(tag_name, text, tokens)
            super
            @text = text
          end
      
          def render(context)
            sponsors = context.registers[:site].data['sponsors']
            output=""
            index=0
            sponsors_by_type = sponsors.group_by {|sponsor| sponsor['type']}
            sponsors_by_type.each do |type, sponsors|
                output += "<div class='panel panel-default'>"
                output += "<div class='panel-heading'>#{type}</div>"
                output += "<div class='panel-body'>"
                sponsors.each do |sponsor|
                    output += "<div class='row'>" if index % 3 == 0
                    output += <<~EOF
                    <div class="col-md-4 col-sm-6 col-xxs-12 animate-box">
                    <a href="#{sponsor['website']}" target="_blank" class="sponsor-item">
                    <img src="images/sponsors/#{sponsor['image']}" alt="#{sponsor['name']}" class="img-responsive center-block" />
                    <div class="text">
                        <h2>#{sponsor['name']} - #{sponsor['type']}</h2>
                        <p>#{sponsor['description']}</p>
                    </div>
                    </a>
                    </div>
                    EOF
                output += "</div>" if index % 3 == 0
                index += 1
                end
                output += "</div></div>"
            end
            return output
        end
    end
end

Liquid::Template.register_tag('sponsors', Jekyll::SponsorsTag)