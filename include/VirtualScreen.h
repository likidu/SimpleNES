#ifndef VIRTUALSCREEN_H
#define VIRTUALSCREEN_H
#include <SFML/Graphics.hpp>
#include <smk/Color.hpp>
#include <smk/VertexArray.hpp>

namespace sn
{
    class VirtualScreen : public sf::Drawable
    {
    public:
        void create(unsigned int width, unsigned int height, float pixel_size, smk::Color color);
        void setPixel(std::size_t x, std::size_t y, smk::Color color);

    private:
        void draw(sf::RenderTarget &target, sf::RenderStates states) const;

        sf::Vector2u m_screenSize;
        float m_pixelSize; // virtual pixel size in real pixels
        smk::VertexArray m_vertices;
    };
};     // namespace sn
#endif // VIRTUALSCREEN_H
