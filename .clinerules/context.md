# Cline LLM Rules for Repository Interaction

## Important: Always Read Context First

Before beginning any task in this repository, Cline (or any other LLM) **MUST** first read and process the `.context/README.md` file to gain a comprehensive understanding of the repository structure, components, and workflows.

## Rule 1: Repository Context Acquisition

1. As the first step for any task, read the `.context/README.md` file to understand:
   - Overall repository purpose and organization
   - Major components and their relationships
   - Development workflows and build processes
   - Integration patterns between components
   - CI/CD workflows and deployment patterns

2. If the task involves specific components, consult the relevant sections of the README for more detailed context about that area.

3. For visualization of repository structures and workflows, refer to the Mermaid diagrams in the `.context/diagrams/` directory.

## Rule 2: Apply Context to Task Execution

1. After acquiring context, frame your approach to the task based on the repository's established patterns and conventions.

2. Follow the established workflows documented in the README for different types of tasks:
   - Helm chart development
   - Infrastructure management
   - Monitoring updates
   - Website development

3. Adhere to the repository conventions for:
   - Documentation
   - Licensing
   - Build systems
   - Code organization
   - Configuration management
   - Package naming

## Rule 3: Context-Aware Tool Usage

1. When using tools like `execute_command`, ensure commands align with the established workflows and conventions documented in the README.

2. For file modifications, ensure changes are consistent with the repository's organization patterns and maintain integration with other components.

3. When writing or modifying code, follow the appropriate technologies and patterns for each component (e.g., Astro for site, Jsonnet for monitoring, Terraform for infrastructure).

## Rule 4: Handling Uncertainty

If you encounter aspects of the repository not covered in the context documentation:

1. Acknowledge the gap in your understanding
2. Make reasonable inferences based on similar patterns observed in the repository
3. Consider searching for additional context in relevant files
4. When necessary, ask clarifying questions about repository-specific conventions or workflows

## Rationale

This repository is a complex, multi-component system with established patterns and conventions. Reading the context documentation first ensures that:

1. Tasks are approached with an understanding of the repository's architecture
2. Changes are consistent with existing patterns and workflows
3. Relationships between components are properly maintained
4. The user receives assistance that aligns with the repository's organization and purpose

Following these rules will result in more effective, contextually appropriate assistance that respects the repository's established structure and conventions.
