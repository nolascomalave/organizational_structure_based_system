export const HTML_RENDER_REPOSITORY = Symbol("HTML_RENDER_REPOSITORY");

export default interface HTMLRenderRepository {
    render(templateName: string, props: Record<string, any>): Promise<string>;
};