import { TapElementsModule } from './tap-elements.module';

describe('TapElementsModule', () => {
  let tapElementsModule: TapElementsModule;

  beforeEach(() => {
    tapElementsModule = new TapElementsModule();
  });

  it('should create an instance', () => {
    expect(tapElementsModule).toBeTruthy();
  });
});
