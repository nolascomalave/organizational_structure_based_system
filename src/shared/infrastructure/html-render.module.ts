import { Global, Module } from "@nestjs/common";
import { HTMLRenderRepository } from "./repositories";
import { HTML_RENDER_REPOSITORY } from "../application/repositories/html-render.repository";

@Global()
@Module({
    providers: [
        {
            provide: HTML_RENDER_REPOSITORY, // token que se inyecta en el handler
            useClass: HTMLRenderRepository, // implementación concreta
        },
    ],
    exports: [HTML_RENDER_REPOSITORY],
})
export class HTMLRenderModule {}